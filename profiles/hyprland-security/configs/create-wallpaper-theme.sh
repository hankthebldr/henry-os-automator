#!/bin/bash
# Wallpaper and Theme Configuration

echo "Creating wallpaper and theme configuration..."

mkdir -p "$HOME/.config/wallpapers"
mkdir -p "$HOME/.config/theme"

# Create a minimal dark wallpaper generator
cat > "$HOME/.config/wallpapers/generate-minimal-wallpaper.sh" << 'EOF'
#!/bin/bash
# Generate Minimal Dark Wallpaper

# Requires ImageMagick
if ! command -v convert &> /dev/null; then
    echo "ImageMagick not installed. Installing..."
    sudo apt install -y imagemagick || sudo pacman -S imagemagick || sudo dnf install -y ImageMagick
fi

# Get screen resolution
RESOLUTION=$(hyprctl monitors -j | jq -r '.[0] | "\(.width)x\(.height)"')
WIDTH=$(echo $RESOLUTION | cut -d'x' -f1)
HEIGHT=$(echo $RESOLUTION | cut -d'x' -f2)

# Fallback to 1920x1080 if detection fails
if [ -z "$WIDTH" ] || [ -z "$HEIGHT" ]; then
    WIDTH=1920
    HEIGHT=1080
fi

OUTPUT="$HOME/.config/wallpapers/minimal-dark.png"

echo "Generating minimal dark wallpaper at ${WIDTH}x${HEIGHT}..."

# Create gradient background
convert -size ${WIDTH}x${HEIGHT} \
    gradient:'#0a0a0a-#1a1a1a' \
    -gravity center \
    "$OUTPUT"

echo "Wallpaper created: $OUTPUT"

# Set wallpaper
if command -v swww &> /dev/null; then
    swww img "$OUTPUT" --transition-type fade --transition-duration 2
    echo "Wallpaper set successfully"
fi
EOF

chmod +x "$HOME/.config/wallpapers/generate-minimal-wallpaper.sh"

# GTK theme configuration
cat > "$HOME/.config/theme/gtk-setup.sh" << 'EOF'
#!/bin/bash
# GTK Theme Configuration

echo "Configuring GTK themes..."

mkdir -p "$HOME/.config/gtk-3.0"
mkdir -p "$HOME/.config/gtk-4.0"

# GTK 3.0 settings
cat > "$HOME/.config/gtk-3.0/settings.ini" << 'GTK3'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-toolbar-style=GTK_TOOLBAR_BOTH_HORIZ
gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
gtk-button-images=0
gtk-menu-images=0
gtk-enable-event-sounds=0
gtk-enable-input-feedback-sounds=0
gtk-xft-antialias=1
gtk-xft-hinting=1
gtk-xft-hintstyle=hintfull
gtk-xft-rgba=rgb
GTK3

# GTK 4.0 settings
cat > "$HOME/.config/gtk-4.0/settings.ini" << 'GTK4'
[Settings]
gtk-application-prefer-dark-theme=1
gtk-theme-name=Adwaita-dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Sans 10
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
GTK4

# Qt theme
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=Adwaita-Dark

echo "GTK themes configured"
echo "Install Papirus icons: sudo apt install papirus-icon-theme"
EOF

chmod +x "$HOME/.config/theme/gtk-setup.sh"

# Cursor theme
cat > "$HOME/.config/theme/cursor-setup.sh" << 'EOF'
#!/bin/bash
# Cursor Theme Configuration

echo "Configuring cursor theme..."

mkdir -p "$HOME/.icons/default"

cat > "$HOME/.icons/default/index.theme" << 'CURSOR'
[Icon Theme]
Name=Default
Comment=Default Cursor Theme
Inherits=Adwaita
CURSOR

# Set cursor size for Hyprland
hyprctl setcursor Adwaita 24

echo "Cursor theme configured"
EOF

chmod +x "$HOME/.config/theme/cursor-setup.sh"

# Auto-start theme configuration
cat > "$HOME/.config/theme/autostart-theme.sh" << 'EOF'
#!/bin/bash
# Theme Autostart Script

# Set wallpaper
if [ -f "$HOME/.config/wallpapers/minimal-dark.png" ]; then
    swww img "$HOME/.config/wallpapers/minimal-dark.png" --transition-type fade --transition-duration 2
fi

# Apply GTK theme
gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Set cursor
hyprctl setcursor Adwaita 24
EOF

chmod +x "$HOME/.config/theme/autostart-theme.sh"

echo -e "${GREEN}✓ Wallpaper and theme configurations created${NC}"
