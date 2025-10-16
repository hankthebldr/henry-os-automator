#!/bin/bash
# Module Orchestration Engine
# Ansible-like module execution with dependency resolution

set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/utils.sh"

# Module registry
MODULES_DIR="${AUTOMATOR_ROOT}/modules"
MODULE_STATE_DIR="$HOME/.henry-automator/state/modules"

mkdir -p "$MODULE_STATE_DIR"

# Parse YAML (basic parser for module.yaml files)
parse_yaml() {
    local yaml_file="$1"
    local prefix="${2:-}"

    python3 - <<EOF
import yaml
import sys
import json

try:
    with open('$yaml_file', 'r') as f:
        data = yaml.safe_load(f)
    print(json.dumps(data))
except Exception as e:
    print(f"Error parsing YAML: {e}", file=sys.stderr)
    sys.exit(1)
EOF
}

# Get module metadata
get_module_info() {
    local module_name="$1"
    local module_dir="$MODULES_DIR/$module_name"
    local module_yaml="$module_dir/module.yaml"

    if [ ! -f "$module_yaml" ]; then
        log_error "Module not found: $module_name"
        return 1
    fi

    parse_yaml "$module_yaml"
}

# Check if module is installed
is_module_installed() {
    local module_name="$1"
    local state_file="$MODULE_STATE_DIR/$module_name.json"

    if [ -f "$state_file" ]; then
        local installed=$(python3 -c "import json; data=json.load(open('$state_file')); print(data.get('installed', False))")
        [ "$installed" == "True" ]
    else
        return 1
    fi
}

# Mark module as installed
mark_module_installed() {
    local module_name="$1"
    local version="$2"
    local state_file="$MODULE_STATE_DIR/$module_name.json"

    python3 - <<EOF
import json
from datetime import datetime

data = {
    "name": "$module_name",
    "version": "$version",
    "installed": True,
    "installed_at": datetime.now().isoformat(),
    "status": "success"
}

with open('$state_file', 'w') as f:
    json.dump(data, f, indent=2)
EOF

    log_success "Module state saved: $module_name"
}

# Resolve module dependencies
resolve_dependencies() {
    local module_name="$1"
    local resolved=()
    local seen=()

    _resolve_deps_recursive() {
        local mod="$1"

        # Check if already seen (circular dependency)
        if [[ " ${seen[@]} " =~ " ${mod} " ]]; then
            return
        fi
        seen+=("$mod")

        # Get module info
        local module_dir="$MODULES_DIR/$mod"
        local module_yaml="$module_dir/module.yaml"

        if [ ! -f "$module_yaml" ]; then
            log_warn "Module not found: $mod (skipping dependencies)"
            return
        fi

        # Extract dependencies
        local deps=$(python3 -c "
import yaml
with open('$module_yaml') as f:
    data = yaml.safe_load(f)
    deps = data.get('dependencies', [])
    print(' '.join(deps))
" 2>/dev/null || echo "")

        # Recursively resolve dependencies
        for dep in $deps; do
            _resolve_deps_recursive "$dep"
        done

        # Add this module if not already in resolved list
        if [[ ! " ${resolved[@]} " =~ " ${mod} " ]]; then
            resolved+=("$mod")
        fi
    }

    _resolve_deps_recursive "$module_name"

    # Return resolved modules
    echo "${resolved[@]}"
}

# Check module compatibility
check_module_compatibility() {
    local module_name="$1"
    local current_os=$(get_os_info)
    local module_yaml="$MODULES_DIR/$module_name/module.yaml"

    if [ ! -f "$module_yaml" ]; then
        return 1
    fi

    local compatible=$(python3 -c "
import yaml
with open('$module_yaml') as f:
    data = yaml.safe_load(f)
    compatible_os = data.get('compatible_os', [])
    print('$current_os' in compatible_os)
" 2>/dev/null || echo "False")

    [ "$compatible" == "True" ]
}

# Execute module task
execute_module_task() {
    local module_name="$1"
    local task="$2"  # install, configure, verify, etc.
    local module_dir="$MODULES_DIR/$module_name"
    local module_yaml="$module_dir/module.yaml"

    if [ ! -f "$module_yaml" ]; then
        log_error "Module YAML not found: $module_yaml"
        return 1
    fi

    # Get task script from YAML
    local task_script=$(python3 -c "
import yaml
with open('$module_yaml') as f:
    data = yaml.safe_load(f)
    tasks = data.get('tasks', {})
    print(tasks.get('$task', ''))
" 2>/dev/null || echo "")

    if [ -z "$task_script" ]; then
        log_warn "No $task script defined for module: $module_name"
        return 0
    fi

    local script_path="$module_dir/$task_script"

    if [ ! -f "$script_path" ]; then
        log_error "Task script not found: $script_path"
        return 1
    fi

    log_info "Executing $task for module: $module_name"

    # Execute in module directory with environment
    (
        cd "$module_dir"
        export MODULE_NAME="$module_name"
        export MODULE_DIR="$module_dir"
        bash "$script_path"
    )
}

# Deploy module files
deploy_module_files() {
    local module_name="$1"
    local module_dir="$MODULES_DIR/$module_name"
    local module_yaml="$module_dir/module.yaml"

    if [ ! -f "$module_yaml" ]; then
        return 0
    fi

    log_info "Deploying files for module: $module_name"

    # Get files list from YAML
    python3 - <<EOF
import yaml
import os

with open('$module_yaml') as f:
    data = yaml.safe_load(f)

files = data.get('files', [])

for file_entry in files:
    src = file_entry.get('src')
    dest = file_entry.get('dest')
    backup = file_entry.get('backup', True)

    if not src or not dest:
        continue

    src_path = os.path.join('$module_dir', src)
    dest_path = os.path.expanduser(dest)

    print(f"{src_path}|{dest_path}|{backup}")
EOF

    # Use bash to handle file operations (via safe_copy function)
    while IFS='|' read -r src dest backup; do
        if [ -f "$src" ]; then
            safe_copy "$src" "$dest"
        else
            log_warn "Source file not found: $src"
        fi
    done < <(python3 - <<EOF
import yaml
import os

with open('$module_yaml') as f:
    data = yaml.safe_load(f)

files = data.get('files', [])

for file_entry in files:
    src = file_entry.get('src')
    dest = file_entry.get('dest')
    backup = file_entry.get('backup', True)

    if not src or not dest:
        continue

    src_path = os.path.join('$module_dir', src)
    dest_path = os.path.expanduser(dest)

    print(f"{src_path}|{dest_path}|{backup}")
EOF
    )
}

# Install module
install_module() {
    local module_name="$1"
    local skip_installed="${2:-false}"

    log_step "Installing module: $module_name"

    # Check if already installed
    if [ "$skip_installed" == "true" ] && is_module_installed "$module_name"; then
        log_info "Module already installed: $module_name (skipping)"
        return 0
    fi

    # Check compatibility
    if ! check_module_compatibility "$module_name"; then
        log_warn "Module not compatible with current OS: $module_name"
        return 1
    fi

    # Get module version
    local version=$(python3 -c "
import yaml
with open('$MODULES_DIR/$module_name/module.yaml') as f:
    data = yaml.safe_load(f)
    print(data.get('version', '1.0.0'))
" 2>/dev/null || echo "1.0.0")

    # Execute tasks
    execute_module_task "$module_name" "pre_install" || true
    execute_module_task "$module_name" "install"
    deploy_module_files "$module_name"
    execute_module_task "$module_name" "configure"
    execute_module_task "$module_name" "post_install" || true

    # Mark as installed
    mark_module_installed "$module_name" "$version"

    # Verify
    if execute_module_task "$module_name" "verify"; then
        log_success "Module installed successfully: $module_name"
    else
        log_warn "Module installed but verification failed: $module_name"
    fi
}

# Install modules with dependency resolution
install_modules() {
    local modules=("$@")

    log_step "Resolving module dependencies..."

    # Resolve all dependencies
    local all_modules=()
    for module in "${modules[@]}"; do
        local resolved=($(resolve_dependencies "$module"))
        for mod in "${resolved[@]}"; do
            if [[ ! " ${all_modules[@]} " =~ " ${mod} " ]]; then
                all_modules+=("$mod")
            fi
        done
    done

    log_info "Installation order: ${all_modules[@]}"
    echo ""

    # Install in order
    local total=${#all_modules[@]}
    local current=0

    for module in "${all_modules[@]}"; do
        ((current++))
        echo ""
        log_step "[$current/$total] Installing: $module"
        install_module "$module" true
    done

    echo ""
    log_success "All modules installed successfully!"
}

# List available modules
list_modules() {
    log_step "Available Modules"
    echo ""

    for module_dir in "$MODULES_DIR"/*; do
        if [ -d "$module_dir" ]; then
            local module_name=$(basename "$module_dir")
            local module_yaml="$module_dir/module.yaml"

            if [ -f "$module_yaml" ]; then
                local description=$(python3 -c "
import yaml
with open('$module_yaml') as f:
    data = yaml.safe_load(f)
    print(data.get('description', 'No description'))
" 2>/dev/null || echo "No description")

                local version=$(python3 -c "
import yaml
with open('$module_yaml') as f:
    data = yaml.safe_load(f)
    print(data.get('version', '1.0.0'))
" 2>/dev/null || echo "1.0.0")

                echo -e "${GREEN}●${NC} ${CYAN}$module_name${NC} ${YELLOW}v$version${NC}"
                echo -e "  $description"

                if is_module_installed "$module_name"; then
                    echo -e "  ${GREEN}✓ Installed${NC}"
                fi
                echo ""
            fi
        fi
    done
}

# Export functions
export -f parse_yaml get_module_info is_module_installed mark_module_installed
export -f resolve_dependencies check_module_compatibility
export -f execute_module_task deploy_module_files
export -f install_module install_modules list_modules
