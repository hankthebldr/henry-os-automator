#!/bin/bash
# Core Utilities for Henry's OS Automator

# Colors for output
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[1;33m'
export BLUE='\033[0;34m'
export MAGENTA='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

# Logging levels
export LOG_LEVEL=${LOG_LEVEL:-"INFO"}
export LOG_FILE="${LOG_FILE:-$HOME/.henry-automator/logs/install.log}"

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Logging functions
log() {
    local level="$1"
    shift
    local message="$*"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] [$level] $message" | tee -a "$LOG_FILE"
}

log_info() {
    echo -e "${BLUE}ℹ${NC} $*"
    log "INFO" "$*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
    log "SUCCESS" "$*"
}

log_warn() {
    echo -e "${YELLOW}⚠${NC} $*"
    log "WARN" "$*"
}

log_error() {
    echo -e "${RED}✗${NC} $*"
    log "ERROR" "$*"
}

log_step() {
    echo -e "\n${CYAN}▸${NC} $*"
    log "STEP" "$*"
}

# Check if running as root
check_not_root() {
    if [[ $EUID -eq 0 ]]; then
        log_error "This script should NOT be run as root"
        log_error "Run as your regular user. It will ask for sudo when needed."
        exit 1
    fi
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Ensure command exists, install if missing
ensure_command() {
    local cmd="$1"
    local package="${2:-$1}"

    if ! command_exists "$cmd"; then
        log_warn "$cmd not found. Installing $package..."
        install_package "$package"
    fi
}

# Get OS information
get_os_info() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$ID"
    else
        log_error "Cannot detect operating system"
        exit 1
    fi
}

get_os_version() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "$VERSION_ID"
    fi
}

# Package manager detection and installation
install_package() {
    local package="$1"
    local os=$(get_os_info)

    case $os in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y "$package"
            ;;
        arch|manjaro)
            sudo pacman -Sy --noconfirm "$package"
            ;;
        fedora)
            sudo dnf install -y "$package"
            ;;
        *)
            log_error "Unsupported distribution: $os"
            return 1
            ;;
    esac
}

install_packages() {
    local os=$(get_os_info)

    case $os in
        ubuntu|debian)
            sudo apt update
            sudo apt install -y "$@"
            ;;
        arch|manjaro)
            sudo pacman -Sy --noconfirm "$@"
            ;;
        fedora)
            sudo dnf install -y "$@"
            ;;
        *)
            log_error "Unsupported distribution: $os"
            return 1
            ;;
    esac
}

# Confirmation prompt
confirm() {
    local prompt="$1"
    local default="${2:-n}"

    if [[ "$NON_INTERACTIVE" == "true" ]]; then
        return 0
    fi

    local yn
    if [[ "$default" == "y" ]]; then
        read -p "$prompt [Y/n]: " yn
        yn=${yn:-y}
    else
        read -p "$prompt [y/N]: " yn
        yn=${yn:-n}
    fi

    case $yn in
        [Yy]* ) return 0;;
        * ) return 1;;
    esac
}

# Create backup of file or directory
backup_path() {
    local path="$1"
    local backup_dir="$HOME/.henry-automator/backups/$(date +%Y%m%d-%H%M%S)"

    if [ -e "$path" ]; then
        mkdir -p "$backup_dir"
        local basename=$(basename "$path")
        cp -r "$path" "$backup_dir/$basename"
        log_info "Backed up $path to $backup_dir/$basename"
        echo "$backup_dir/$basename"
    fi
}

# Safe copy with backup
safe_copy() {
    local src="$1"
    local dest="$2"

    if [ -e "$dest" ]; then
        if ! confirm "File $dest already exists. Overwrite?" "n"; then
            log_info "Skipping $dest"
            return 1
        fi
        backup_path "$dest"
    fi

    mkdir -p "$(dirname "$dest")"
    cp -r "$src" "$dest"
    log_success "Copied $src to $dest"
}

# Create symlink with backup
safe_symlink() {
    local target="$1"
    local link_name="$2"

    if [ -e "$link_name" ] || [ -L "$link_name" ]; then
        if [ -L "$link_name" ]; then
            local current_target=$(readlink "$link_name")
            if [ "$current_target" == "$target" ]; then
                log_info "Symlink $link_name already points to $target"
                return 0
            fi
        fi

        if ! confirm "Path $link_name already exists. Replace with symlink?" "n"; then
            log_info "Skipping symlink for $link_name"
            return 1
        fi
        backup_path "$link_name"
        rm -rf "$link_name"
    fi

    mkdir -p "$(dirname "$link_name")"
    ln -s "$target" "$link_name"
    log_success "Created symlink: $link_name -> $target"
}

# Download file with retries
download_file() {
    local url="$1"
    local dest="$2"
    local retries=3

    for i in $(seq 1 $retries); do
        if curl -fsSL "$url" -o "$dest"; then
            log_success "Downloaded $url"
            return 0
        else
            log_warn "Download attempt $i failed"
            sleep 2
        fi
    done

    log_error "Failed to download $url after $retries attempts"
    return 1
}

# Clone or update git repository
clone_or_update_repo() {
    local repo_url="$1"
    local dest_dir="$2"
    local branch="${3:-main}"

    if [ -d "$dest_dir/.git" ]; then
        log_info "Updating repository at $dest_dir"
        (cd "$dest_dir" && git pull origin "$branch")
    else
        log_info "Cloning repository $repo_url"
        git clone --branch "$branch" "$repo_url" "$dest_dir"
    fi
}

# State management
STATE_DIR="$HOME/.henry-automator/state"
STATE_FILE="$STATE_DIR/installed.json"

init_state() {
    mkdir -p "$STATE_DIR"
    if [ ! -f "$STATE_FILE" ]; then
        echo '{"profiles":{},"modules":{},"installed_at":null}' > "$STATE_FILE"
    fi
}

save_state() {
    local key="$1"
    local value="$2"

    init_state

    # Using python for JSON manipulation (more reliable than jq)
    python3 - <<EOF
import json
import sys

try:
    with open('$STATE_FILE', 'r') as f:
        state = json.load(f)

    keys = '$key'.split('.')
    current = state
    for k in keys[:-1]:
        if k not in current:
            current[k] = {}
        current = current[k]

    current[keys[-1]] = '$value'

    with open('$STATE_FILE', 'w') as f:
        json.dump(state, f, indent=2)
except Exception as e:
    print(f"Error saving state: {e}", file=sys.stderr)
    sys.exit(1)
EOF
}

get_state() {
    local key="$1"
    init_state

    python3 - <<EOF
import json
import sys

try:
    with open('$STATE_FILE', 'r') as f:
        state = json.load(f)

    keys = '$key'.split('.')
    current = state
    for k in keys:
        if k not in current:
            print('')
            sys.exit(0)
        current = current[k]

    print(current)
except Exception as e:
    print('', file=sys.stderr)
    sys.exit(1)
EOF
}

# Check if profile is installed
is_profile_installed() {
    local profile="$1"
    local installed=$(get_state "profiles.$profile.installed")
    [ "$installed" == "True" ] || [ "$installed" == "true" ]
}

# Mark profile as installed
mark_profile_installed() {
    local profile="$1"
    save_state "profiles.$profile.installed" "true"
    save_state "profiles.$profile.installed_at" "$(date -Iseconds)"
}

# Progress bar
show_progress() {
    local current="$1"
    local total="$2"
    local width=50
    local percentage=$((current * 100 / total))
    local filled=$((width * current / total))
    local empty=$((width - filled))

    printf "\r["
    printf "%${filled}s" | tr ' ' '='
    printf "%${empty}s" | tr ' ' ' '
    printf "] %d%%" "$percentage"
}

# Banner
show_banner() {
    echo -e "${CYAN}"
    cat << "EOF"
╔═══════════════════════════════════════════════════════════╗
║                                                           ║
║       Henry's OS Automator                                ║
║       Automated Setup & Configuration                     ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝
EOF
    echo -e "${NC}"
}

# Export functions
export -f log log_info log_success log_warn log_error log_step
export -f check_not_root command_exists ensure_command
export -f get_os_info get_os_version
export -f install_package install_packages
export -f confirm backup_path safe_copy safe_symlink
export -f download_file clone_or_update_repo
export -f init_state save_state get_state
export -f is_profile_installed mark_profile_installed
export -f show_progress show_banner
