#!/bin/bash
# Install Modern Fonts and Icons for Parrot Security
# Enhances MATE desktop with modern typography and iconography

set -euo pipefail

source "$(dirname "$0")/../../../core/utils.sh"

log_step "Installing Modern Fonts and Icons"

# Nerd Fonts (for terminal with icons)
log_info "Installing Nerd Fonts..."

NERD_FONTS=(
    "JetBrainsMono"
    "FiraCode"
    "Hack"
    "SourceCodePro"
    "UbuntuMono"
)

mkdir -p ~/.local/share/fonts

for font in "${NERD_FONTS[@]}"; do
    log_info "Installing ${font} Nerd Font..."

    FONT_URL="https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.zip"
    TMP_FILE="/tmp/${font}.zip"

    if download_file "$FONT_URL" "$TMP_FILE"; then
        unzip -q -o "$TMP_FILE" -d ~/.local/share/fonts/ "*.ttf" 2>/dev/null || true
        rm "$TMP_FILE"
        log_success "${font} installed"
    else
        log_warn "Failed to download ${font}"
    fi
done

# System fonts
log_info "Installing system fonts..."

install_packages \
    fonts-firacode \
    fonts-hack \
    fonts-liberation \
    fonts-liberation2 \
    fonts-noto \
    fonts-noto-color-emoji \
    fonts-roboto \
    fonts-ubuntu \
    fonts-font-awesome \
    fonts-powerline

# Icon themes
log_info "Installing modern icon themes..."

install_packages \
    papirus-icon-theme \
    numix-icon-theme \
    moka-icon-theme

# Additional icon sets
if ! [ -d ~/.local/share/icons/Papirus-Dark ]; then
    log_info "Installing Papirus Dark icons..."
    wget -qO- https://git.io/papirus-icon-theme-install | sh
fi

# Refresh font cache
log_info "Refreshing font cache..."
fc-cache -f -v

# Configure MATE to use modern fonts
log_info "Configuring MATE desktop fonts..."

if command_exists gsettings; then
    # Interface font
    gsettings set org.mate.interface font-name 'Ubuntu 11' || true

    # Document font
    gsettings set org.mate.interface document-font-name 'Sans 11' || true

    # Monospace font (terminal)
    gsettings set org.mate.interface monospace-font-name 'JetBrainsMono Nerd Font Mono 10' || true

    # Window title font
    gsettings set org.mate.Marco.general titlebar-font 'Ubuntu Bold 11' || true

    # Desktop font
    gsettings set org.mate.caja.desktop font 'Ubuntu 10' || true

    # Icon theme
    gsettings set org.mate.interface icon-theme 'Papirus-Dark' || true

    log_success "MATE fonts configured"
fi

# Configure terminal (mate-terminal)
if command_exists dconf; then
    # Get default profile
    PROFILE=$(dconf read /org/mate/terminal/global/profile-list | tr -d "[]'" | cut -d',' -f1)

    if [ -n "$PROFILE" ]; then
        log_info "Configuring mate-terminal with JetBrainsMono..."

        # Set JetBrainsMono Nerd Font
        dconf write /org/mate/terminal/profiles/$PROFILE/use-system-font false || true
        dconf write /org/mate/terminal/profiles/$PROFILE/font "'JetBrainsMono Nerd Font Mono 11'" || true

        log_success "Terminal font configured"
    fi
fi

# Create font configuration for modern tools
mkdir -p ~/.config/fontconfig

cat > ~/.config/fontconfig/fonts.conf << 'EOF'
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
  <!-- Default fonts -->
  <alias>
    <family>sans-serif</family>
    <prefer>
      <family>Ubuntu</family>
      <family>Noto Sans</family>
      <family>Liberation Sans</family>
    </prefer>
  </alias>

  <alias>
    <family>serif</family>
    <prefer>
      <family>Noto Serif</family>
      <family>Liberation Serif</family>
    </prefer>
  </alias>

  <alias>
    <family>monospace</family>
    <prefer>
      <family>JetBrainsMono Nerd Font Mono</family>
      <family>FiraCode Nerd Font Mono</family>
      <family>Hack Nerd Font Mono</family>
      <family>Source Code Pro</family>
    </prefer>
  </alias>

  <!-- Emoji support -->
  <alias>
    <family>emoji</family>
    <prefer>
      <family>Noto Color Emoji</family>
      <family>Font Awesome 6 Free</family>
    </prefer>
  </alias>

  <!-- Font rendering -->
  <match target="font">
    <edit name="antialias" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hinting" mode="assign">
      <bool>true</bool>
    </edit>
    <edit name="hintstyle" mode="assign">
      <const>hintslight</const>
    </edit>
    <edit name="rgba" mode="assign">
      <const>rgb</const>
    </edit>
    <edit name="lcdfilter" mode="assign">
      <const>lcddefault</const>
    </edit>
  </match>
</fontconfig>
EOF

log_success "Font configuration created"

# Install Font Manager (optional GUI tool)
log_info "Installing Font Manager..."
install_packages font-manager || log_warn "Font Manager not available"

# Verify installations
echo ""
log_step "Verification"

log_info "Installed fonts:"
fc-list | grep -i "nerd\|jetbrains\|fira" | wc -l
echo "  $(fc-list | grep -i "nerd\|jetbrains\|fira" | wc -l) Nerd Font variants found"

log_info "Icon themes:"
if [ -d ~/.local/share/icons/Papirus-Dark ]; then
    echo "  ✓ Papirus Dark installed"
fi
if [ -d /usr/share/icons/Numix ]; then
    echo "  ✓ Numix installed"
fi

log_success "Modern fonts and icons installation complete!"

echo ""
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║              Fonts & Icons Installed                      ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""
echo "Nerd Fonts (with icon support):"
echo "  • JetBrainsMono Nerd Font (recommended for terminals)"
echo "  • FiraCode Nerd Font (ligature support)"
echo "  • Hack Nerd Font"
echo "  • Source Code Pro Nerd Font"
echo ""
echo "System Fonts:"
echo "  • Ubuntu (interface font)"
echo "  • Noto Sans/Serif"
echo "  • Liberation fonts"
echo "  • Font Awesome (icons)"
echo "  • Noto Color Emoji"
echo ""
echo "Icon Themes:"
echo "  • Papirus Dark (recommended)"
echo "  • Numix"
echo "  • Moka"
echo ""
echo "Configuration:"
echo "  • MATE desktop updated to use modern fonts"
echo "  • Terminal configured with JetBrainsMono Nerd Font"
echo "  • Font rendering optimized (subpixel anti-aliasing)"
echo ""
echo "Manual steps:"
echo "  1. Restart MATE panels: killall mate-panel"
echo "  2. Restart terminal for font changes"
echo "  3. Optional: Use Font Manager GUI to customize"
echo ""
