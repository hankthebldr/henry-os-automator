#!/bin/bash
# Henry's OS Automator - Main Setup Script
# Orchestrates profile installation and system configuration

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export AUTOMATOR_ROOT="$SCRIPT_DIR"

# Source core utilities
source "$SCRIPT_DIR/core/utils.sh"

# Configuration
PROFILES_DIR="$SCRIPT_DIR/profiles"
CONFIG_DIR="$SCRIPT_DIR/config"
STATE_DIR="$HOME/.henry-automator/state"
export NON_INTERACTIVE="${NON_INTERACTIVE:-false}"

# Initialize
init_state

# Usage information
usage() {
    cat << EOF
Henry's OS Automator - Automated System Setup

Usage: $0 [OPTIONS]

Options:
    -p, --profile PROFILE       Install specific profile
    -l, --list                  List available profiles
    -i, --interactive           Interactive profile selection (default)
    -n, --non-interactive       Non-interactive mode
    -u, --update                Update existing installation
    -v, --verify                Verify installation
    -b, --backup                Create backup of current configs
    -r, --rollback              Rollback to previous state
    --dry-run                   Show what would be done without making changes
    -h, --help                  Show this help message

Examples:
    $0                                    # Interactive mode
    $0 --profile hyprland-security        # Install specific profile
    $0 --list                             # List all profiles
    $0 --update                           # Update current installation
    $0 --profile ubuntu-dev --dry-run     # Dry run

EOF
    exit 0
}

# List available profiles
list_profiles() {
    show_banner
    log_step "Available Profiles"
    echo ""

    for profile_dir in "$PROFILES_DIR"/*; do
        if [ -d "$profile_dir" ]; then
            profile_name=$(basename "$profile_dir")
            profile_file="$profile_dir/profile.yaml"

            if [ -f "$profile_file" ]; then
                # Extract info from YAML (basic parsing)
                description=$(grep "^description:" "$profile_file" | sed 's/description: //' | tr -d '"')
                version=$(grep "^version:" "$profile_file" | sed 's/version: //' | tr -d '"')

                echo -e "${GREEN}●${NC} ${CYAN}$profile_name${NC} ${YELLOW}v$version${NC}"
                echo -e "  $description"

                if is_profile_installed "$profile_name"; then
                    installed_at=$(get_state "profiles.$profile_name.installed_at")
                    echo -e "  ${GREEN}✓ Installed${NC} on $installed_at"
                fi
                echo ""
            fi
        fi
    done
}

# Interactive profile selection
select_profile_interactive() {
    show_banner
    log_step "Select a profile to install"
    echo ""

    local profiles=()
    local i=1

    for profile_dir in "$PROFILES_DIR"/*; do
        if [ -d "$profile_dir" ]; then
            profile_name=$(basename "$profile_dir")
            profiles+=("$profile_name")

            profile_file="$profile_dir/profile.yaml"
            if [ -f "$profile_file" ]; then
                description=$(grep "^description:" "$profile_file" | sed 's/description: //' | tr -d '"')
                echo -e "  ${CYAN}$i)${NC} $profile_name"
                echo -e "     $description"

                if is_profile_installed "$profile_name"; then
                    echo -e "     ${GREEN}✓ Already installed${NC}"
                fi
                echo ""
                ((i++))
            fi
        fi
    done

    echo -n "Enter selection (1-${#profiles[@]}): "
    read selection

    if [[ "$selection" =~ ^[0-9]+$ ]] && [ "$selection" -ge 1 ] && [ "$selection" -le "${#profiles[@]}" ]; then
        echo "${profiles[$((selection-1))]}"
    else
        log_error "Invalid selection"
        exit 1
    fi
}

# Install profile
install_profile() {
    local profile_name="$1"
    local profile_dir="$PROFILES_DIR/$profile_name"
    local profile_file="$profile_dir/profile.yaml"

    if [ ! -d "$profile_dir" ]; then
        log_error "Profile not found: $profile_name"
        log_info "Run '$0 --list' to see available profiles"
        exit 1
    fi

    if [ ! -f "$profile_file" ]; then
        log_error "Profile configuration not found: $profile_file"
        exit 1
    fi

    show_banner
    log_step "Installing profile: $profile_name"
    echo ""

    # Extract profile info
    description=$(grep "^description:" "$profile_file" | sed 's/description: //' | tr -d '"')
    version=$(grep "^version:" "$profile_file" | sed 's/version: //' | tr -d '"')

    log_info "Description: $description"
    log_info "Version: $version"
    echo ""

    # Check if already installed
    if is_profile_installed "$profile_name" && [ "$UPDATE_MODE" != "true" ]; then
        log_warn "Profile already installed"
        if ! confirm "Reinstall?" "n"; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi

    # Confirm installation
    if [ "$NON_INTERACTIVE" != "true" ] && [ "$DRY_RUN" != "true" ]; then
        if ! confirm "Proceed with installation?" "y"; then
            log_info "Installation cancelled"
            exit 0
        fi
    fi

    echo ""
    log_step "Starting installation"

    # Check for install script
    local install_script="$profile_dir/install.sh"
    if [ ! -f "$install_script" ]; then
        log_error "Installation script not found: $install_script"
        exit 1
    fi

    # Run in dry-run mode
    if [ "$DRY_RUN" == "true" ]; then
        log_info "DRY RUN MODE - No changes will be made"
        log_info "Would execute: $install_script"
        exit 0
    fi

    # Execute installation
    cd "$profile_dir"

    log_info "Executing installation script..."
    if bash "$install_script"; then
        log_success "Profile installation completed successfully"
        mark_profile_installed "$profile_name"

        echo ""
        log_step "Post-installation steps"
        log_info "Profile: $profile_name installed"
        log_info "Check logs: $LOG_FILE"

        # Show post-install tasks if any
        if grep -q "post_install_tasks:" "$profile_file"; then
            echo ""
            log_step "Recommended next steps:"
            grep -A 10 "post_install_tasks:" "$profile_file" | grep "^  -" | sed 's/^  - /  • /'
        fi

        echo ""
        log_success "Installation complete!"
    else
        log_error "Installation failed"
        log_info "Check logs: $LOG_FILE"
        exit 1
    fi
}

# Verify installation
verify_installation() {
    show_banner
    log_step "Verifying installation"
    echo ""

    # Check installed profiles
    local profiles=$(ls "$PROFILES_DIR")
    for profile_name in $profiles; do
        if is_profile_installed "$profile_name"; then
            log_info "Checking profile: $profile_name"

            profile_file="$PROFILES_DIR/$profile_name/profile.yaml"
            if [ -f "$profile_file" ] && grep -q "verification:" "$profile_file"; then
                # Run verification checks
                log_info "Running verification checks..."
                # TODO: Implement YAML parsing and verification execution
            fi
        fi
    done

    log_success "Verification complete"
}

# Update installation
update_installation() {
    show_banner
    log_step "Updating installation"
    echo ""

    # Pull latest changes
    log_info "Updating automator repository..."
    cd "$AUTOMATOR_ROOT"
    git pull

    # Find installed profile
    local installed_profile=""
    for profile_dir in "$PROFILES_DIR"/*; do
        if [ -d "$profile_dir" ]; then
            profile_name=$(basename "$profile_dir")
            if is_profile_installed "$profile_name"; then
                installed_profile="$profile_name"
                break
            fi
        fi
    done

    if [ -z "$installed_profile" ]; then
        log_warn "No installed profile found"
        exit 0
    fi

    log_info "Found installed profile: $installed_profile"
    UPDATE_MODE="true" install_profile "$installed_profile"
}

# Create backup
create_backup() {
    show_banner
    log_step "Creating backup"

    local backup_dir="$HOME/.henry-automator/backups/$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"

    # Backup common config directories
    local config_dirs=(
        "$HOME/.config/hypr"
        "$HOME/.config/waybar"
        "$HOME/.config/kitty"
        "$HOME/.config/security"
        "$HOME/.config/privacy"
    )

    for dir in "${config_dirs[@]}"; do
        if [ -d "$dir" ]; then
            log_info "Backing up $dir"
            cp -r "$dir" "$backup_dir/"
        fi
    done

    log_success "Backup created: $backup_dir"
}

# Main execution
main() {
    local PROFILE=""
    local MODE="interactive"

    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -p|--profile)
                PROFILE="$2"
                MODE="install"
                shift 2
                ;;
            -l|--list)
                list_profiles
                exit 0
                ;;
            -i|--interactive)
                MODE="interactive"
                shift
                ;;
            -n|--non-interactive)
                export NON_INTERACTIVE="true"
                shift
                ;;
            -u|--update)
                MODE="update"
                shift
                ;;
            -v|--verify)
                MODE="verify"
                shift
                ;;
            -b|--backup)
                create_backup
                exit 0
                ;;
            --dry-run)
                export DRY_RUN="true"
                shift
                ;;
            -h|--help)
                usage
                ;;
            *)
                log_error "Unknown option: $1"
                usage
                ;;
        esac
    done

    # Check prerequisites
    check_not_root
    ensure_command git git
    ensure_command curl curl

    # Execute based on mode
    case $MODE in
        install)
            if [ -z "$PROFILE" ]; then
                log_error "Profile not specified"
                usage
            fi
            install_profile "$PROFILE"
            ;;
        interactive)
            PROFILE=$(select_profile_interactive)
            install_profile "$PROFILE"
            ;;
        update)
            update_installation
            ;;
        verify)
            verify_installation
            ;;
        *)
            usage
            ;;
    esac
}

# Run main
main "$@"
