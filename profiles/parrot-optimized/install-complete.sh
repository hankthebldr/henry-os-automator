#!/bin/bash
# Parrot Security - Complete System Installation
# Cumulative dependency-resolved installation with maximum optimization

set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AUTOMATOR_ROOT="$(cd "$PROFILE_DIR/../.." && pwd)"

# Source core utilities and orchestrator
source "$AUTOMATOR_ROOT/core/utils.sh"
source "$AUTOMATOR_ROOT/core/orchestrator.sh"

# Display banner
show_banner

log_step "Parrot Security - Maximum Optimized Installation"
echo ""
log_info "Profile: parrot-optimized v2.0.0"
log_info "Target: Parrot Security 6.4 | AMD Ryzen 9 7945HX | 62GB RAM"
echo ""

# Check prerequisites
check_not_root
ensure_command git git
ensure_command curl curl
ensure_command python3 python3

# Verify system
log_step "System Verification"
OS=$(get_os_info)
OS_VERSION=$(get_os_version)
CPU_CORES=$(nproc)
MEM_GB=$(free -g | awk '/^Mem:/{print $2}')

log_info "OS: $OS $OS_VERSION"
log_info "CPU Cores: $CPU_CORES"
log_info "Memory: ${MEM_GB}GB"

if [ "$CPU_CORES" -lt 8 ]; then
    log_warn "Less than 8 CPU cores detected. Some optimizations may not apply."
fi

if [ "$MEM_GB" -lt 8 ]; then
    log_error "Minimum 8GB RAM required"
    exit 1
fi

echo ""

# Confirm installation
if ! confirm "This will install a complete system configuration. Proceed?" "y"; then
    log_info "Installation cancelled"
    exit 0
fi

echo ""

# Phase 1: System Foundation
log_step "PHASE 1: System Foundation"
log_info "Installing essential packages and monitoring tools..."
echo ""

bash "$PROFILE_DIR/scripts/10-system-foundation.sh"

# Phase 2: System Optimizations
log_step "PHASE 2: System Optimizations"
log_info "Applying kernel tuning and performance optimizations..."
echo ""

bash "$PROFILE_DIR/scripts/20-system-optimizations.sh"

# Phase 3: Shell Environment
log_step "PHASE 3: Shell Environment"
log_info "Configuring shell and modern CLI tools..."
echo ""

bash "$PROFILE_DIR/scripts/30-shell-environment.sh"

# Phase 4: Development Tools
log_step "PHASE 4: Development Tools"
log_info "Setting up development environment..."
echo ""

bash "$PROFILE_DIR/scripts/40-development-tools.sh"

# Phase 5: Programming Languages
log_step "PHASE 5: Programming Languages"
log_info "Installing programming language stacks..."
echo ""

bash "$PROFILE_DIR/scripts/50-programming-languages.sh"

# Phase 6: Security Hardening
log_step "PHASE 6: Security Hardening"
log_info "Applying security configurations..."
echo ""

bash "$PROFILE_DIR/scripts/60-security-hardening.sh"

# Phase 7: AI/ML Stack (Optional)
if confirm "Install AI/ML stack (Ollama, LangChain, RAG)?" "y"; then
    log_step "PHASE 7: AI/ML Stack"
    log_info "Installing AI/ML infrastructure..."
    echo ""

    bash "$PROFILE_DIR/scripts/70-ai-ml-stack.sh"
fi

# Phase 8: Performance Tuning
log_step "PHASE 8: Performance Tuning"
log_info "Final performance optimizations..."
echo ""

bash "$PROFILE_DIR/scripts/80-performance-tuning.sh"

# Phase 9: Post-Install
log_step "PHASE 9: Post-Install Verification"
log_info "Running verification checks..."
echo ""

bash "$PROFILE_DIR/scripts/90-post-install.sh"

# Generate summary report
echo ""
log_step "Installation Complete!"
echo ""

cat << EOF
╔═══════════════════════════════════════════════════════════╗
║           System Configuration Complete!                  ║
╚═══════════════════════════════════════════════════════════╝

Installation Summary:
---------------------
✓ System monitoring tools installed
✓ Kernel optimizations applied
✓ Shell environment configured
✓ Development tools set up
✓ Programming languages installed
✓ Security hardening applied
✓ AI/ML stack configured
✓ Performance tuning complete

System Specifications:
---------------------
OS: $OS $OS_VERSION
CPU: AMD Ryzen 9 7945HX ($CPU_CORES threads)
RAM: ${MEM_GB}GB
Parallel Jobs: MAKEFLAGS=-j$CPU_CORES

Next Steps:
---------------------
1. Restart your terminal or run: source ~/.zshrc  (or ~/.bashrc)
2. Verify installation: neofetch
3. Check optimizations: sysctl vm.swappiness
4. Run security audit: sudo lynis audit system
5. Test AI/ML: ollama run llama3.1:8b

Quick Reference:
---------------------
• System monitor: btop
• GPU monitor: nvtop
• I/O monitor: sudo iotop
• Disk usage: ncdu
• NVMe health: sudo nvme smart-log /dev/nvme0n1

• Git aliases: git aliases
• Tmux: tmux (Ctrl+a is prefix)
• Neovim: nvim

• LLM inference: ollama run llama3.1:8b
• RAG example: python3 ~/.config/ai-tools/rag_example.py

Documentation:
---------------------
• Full setup guide: $PROFILE_DIR/README.md
• Module index: $AUTOMATOR_ROOT/DOTFILES_MODULE_INDEX.md
• System optimizations: ~/Github/dot-files/configs/SYSTEM_OPTIMIZATIONS.md
• LLM/RAG setup: ~/Github/dot-files/configs/LLM_RAG_SETUP.md

Configuration Files:
---------------------
• Shell: ~/.zshrc or ~/.bashrc
• Git: ~/.gitconfig
• Tmux: ~/.tmux.conf
• Neovim: ~/.config/nvim/init.vim
• System: /etc/sysctl.d/99-custom.conf

Support:
---------------------
• Check logs: $LOG_FILE
• State tracking: ~/.henry-automator/state/
• Backups: ~/.henry-automator/backups/

╔═══════════════════════════════════════════════════════════╗
║  Enjoy your maximum optimized Parrot Security system!     ║
╚═══════════════════════════════════════════════════════════╝

EOF

log_info "Installation log saved to: $LOG_FILE"
echo ""
