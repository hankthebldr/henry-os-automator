#!/bin/bash
# Secure Minimal Desktop Environment Setup Script
# Immersive, minimal design with security hardening
# Target: Hyprland + Waybar + Security Tools

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging
LOGFILE="$HOME/secure-desktop-install.log"
exec > >(tee -a "$LOGFILE")
exec 2>&1

echo -e "${BLUE}═══════════════════════════════════════════════${NC}"
echo -e "${BLUE}   Secure Minimal Desktop Environment Setup${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}This script should NOT be run as root${NC}"
   echo "Run as your regular user. It will ask for sudo when needed."
   exit 1
fi

# Detect distribution
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO=$ID
else
    echo -e "${RED}Cannot detect distribution${NC}"
    exit 1
fi

echo -e "${GREEN}Detected distribution: $DISTRO${NC}"

# Function to install packages based on distro
install_packages() {
    case $DISTRO in
        debian|ubuntu)
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
            echo -e "${RED}Unsupported distribution${NC}"
            exit 1
            ;;
    esac
}

# Core security packages
SECURITY_PACKAGES=(
    "ufw"                   # Uncomplicated Firewall
    "fail2ban"             # Intrusion prevention
    "apparmor"             # Mandatory Access Control
    "apparmor-utils"       # AppArmor utilities
    "rkhunter"             # Rootkit scanner
    "clamav"               # Antivirus
    "firejail"             # Sandboxing
    "lynis"                # Security auditing
    "bleachbit"            # Privacy cleaner
)

# Desktop environment packages
DESKTOP_PACKAGES=(
    "hyprland"             # Wayland compositor
    "waybar"               # Status bar
    "wofi"                 # App launcher (rofi alternative for Wayland)
    "dunst"                # Notification daemon
    "kitty"                # GPU-accelerated terminal
    "swaylock-effects"     # Screen locker with effects
    "swayidle"             # Idle management
    "wl-clipboard"         # Clipboard utilities
    "grim"                 # Screenshot tool
    "slurp"                # Screen area selection
    "swww"                 # Wallpaper daemon
    "polkit-gnome"         # Authentication agent
)

# Additional tools
TOOLS_PACKAGES=(
    "git"
    "curl"
    "wget"
    "htop"
    "btop"
    "neovim"
    "ripgrep"
    "fd-find"
    "fzf"
    "tmux"
    "ranger"               # File manager
    "mpv"                  # Media player
    "imv"                  # Image viewer
    "zathura"              # PDF viewer
)

echo -e "\n${YELLOW}Step 1: Installing security packages${NC}"
for pkg in "${SECURITY_PACKAGES[@]}"; do
    echo "Installing $pkg..."
    install_packages "$pkg" || echo -e "${YELLOW}Warning: Could not install $pkg${NC}"
done

echo -e "\n${YELLOW}Step 2: Installing desktop environment${NC}"
for pkg in "${DESKTOP_PACKAGES[@]}"; do
    echo "Installing $pkg..."
    install_packages "$pkg" || echo -e "${YELLOW}Warning: Could not install $pkg${NC}"
done

echo -e "\n${YELLOW}Step 3: Installing additional tools${NC}"
for pkg in "${TOOLS_PACKAGES[@]}"; do
    echo "Installing $pkg..."
    install_packages "$pkg" || echo -e "${YELLOW}Warning: Could not install $pkg${NC}"
done

echo -e "\n${YELLOW}Step 4: Configuring security hardening${NC}"

# Enable and configure UFW
echo "Configuring firewall..."
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw limit ssh
sudo ufw --force enable

# Configure fail2ban
echo "Configuring fail2ban..."
sudo systemctl enable fail2ban
sudo systemctl start fail2ban

# Enable AppArmor
echo "Enabling AppArmor..."
sudo systemctl enable apparmor
sudo systemctl start apparmor

# Create configuration directories
mkdir -p "$HOME/.config/hypr"
mkdir -p "$HOME/.config/waybar"
mkdir -p "$HOME/.config/kitty"
mkdir -p "$HOME/.config/wofi"
mkdir -p "$HOME/.config/dunst"
mkdir -p "$HOME/.config/swaylock"

echo -e "\n${YELLOW}Step 5: Creating configuration files${NC}"

# Source the configuration files
source "$(dirname "$0")/configs/create-hyprland-config.sh"
source "$(dirname "$0")/configs/create-waybar-config.sh"
source "$(dirname "$0")/configs/create-terminal-config.sh"
source "$(dirname "$0")/configs/create-security-config.sh"

echo -e "\n${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "${GREEN}   Installation Complete!${NC}"
echo -e "${GREEN}═══════════════════════════════════════════════${NC}"
echo -e "\nNext steps:"
echo -e "1. Reboot your system"
echo -e "2. Select Hyprland from your display manager"
echo -e "3. Review security settings in ~/.config/security/"
echo -e "4. Check log file: $LOGFILE"
echo -e "\n${YELLOW}Security recommendations:${NC}"
echo -e "- Run: sudo lynis audit system"
echo -e "- Run: sudo rkhunter --check"
echo -e "- Review firewall rules: sudo ufw status verbose"
echo -e "- Check AppArmor status: sudo aa-status"
