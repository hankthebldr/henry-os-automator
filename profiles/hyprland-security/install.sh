#!/bin/bash
# Hyprland Security Profile Installation Wrapper

set -euo pipefail

PROFILE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROFILE_NAME="hyprland-security"

echo "Installing profile: $PROFILE_NAME"
echo "Profile directory: $PROFILE_DIR"

# Source the main installation script
source "$PROFILE_DIR/secure-desktop-setup.sh"
