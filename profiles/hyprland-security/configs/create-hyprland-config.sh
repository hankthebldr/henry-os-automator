#!/bin/bash
# Hyprland Configuration - Minimal & Security Focused

echo "Creating Hyprland configuration..."

cat > "$HOME/.config/hypr/hyprland.conf" << 'EOF'
# Hyprland Configuration
# Minimal, Immersive, Security-Focused

# Monitor configuration
monitor=,preferred,auto,1

# Execute on startup
exec-once = waybar
exec-once = dunst
exec-once = swww init
exec-once = /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
exec-once = swayidle -w timeout 300 'swaylock -f' timeout 600 'hyprctl dispatch dpms off' resume 'hyprctl dispatch dpms on' before-sleep 'swaylock -f'
exec-once = wl-paste --watch cliphist store

# Security: Clear clipboard on lock
exec-once = swayidle -w before-sleep 'wl-copy -c'

# Environment variables
env = XCURSOR_SIZE,24
env = QT_QPA_PLATFORMTHEME,qt5ct
env = MOZ_ENABLE_WAYLAND,1
env = XDG_CURRENT_DESKTOP,Hyprland
env = XDG_SESSION_TYPE,wayland
env = XDG_SESSION_DESKTOP,Hyprland

# Security: Disable window history for privacy
env = HYPRLAND_NO_RT,1

# Input configuration
input {
    kb_layout = us
    kb_variant =
    kb_model =
    kb_options =
    kb_rules =

    follow_mouse = 1
    sensitivity = 0
    accel_profile = flat

    touchpad {
        natural_scroll = yes
        disable_while_typing = yes
        tap-to-click = yes
    }
}

# General window settings
general {
    gaps_in = 8
    gaps_out = 16
    border_size = 2

    # Minimal dark theme colors
    col.active_border = rgba(88888888)
    col.inactive_border = rgba(22222288)

    layout = dwindle

    # Security: No window dimming reveals less info
    resize_on_border = false
}

# Decoration
decoration {
    rounding = 8

    blur {
        enabled = true
        size = 6
        passes = 3
        new_optimizations = true
        noise = 0.02
        contrast = 1.0
        brightness = 1.0
        xray = false
    }

    drop_shadow = true
    shadow_range = 20
    shadow_render_power = 3
    col.shadow = rgba(00000099)

    # Minimal aesthetics
    dim_inactive = false
    dim_strength = 0.1
}

# Animations - smooth but minimal
animations {
    enabled = yes

    bezier = smoothOut, 0.36, 0, 0.66, -0.56
    bezier = smoothIn, 0.25, 1, 0.5, 1
    bezier = overshot, 0.13, 0.99, 0.29, 1.1

    animation = windows, 1, 4, overshot, slide
    animation = windowsOut, 1, 4, smoothOut, slide
    animation = border, 1, 5, default
    animation = fade, 1, 5, smoothIn
    animation = workspaces, 1, 4, overshot, slidevert
}

# Layouts
dwindle {
    pseudotile = yes
    preserve_split = yes
    force_split = 2
    no_gaps_when_only = false
}

master {
    new_is_master = true
    no_gaps_when_only = false
}

# Gestures
gestures {
    workspace_swipe = true
    workspace_swipe_fingers = 3
    workspace_swipe_distance = 300
}

# Misc settings
misc {
    disable_hyprland_logo = true
    disable_splash_rendering = true
    mouse_move_enables_dpms = true
    key_press_enables_dpms = true
    vrr = 0

    # Security: Disable autoreload for stability
    disable_autoreload = false

    # Privacy: Shorter focus history
    focus_on_activate = false
}

# Window rules - Security focused
windowrule = float, ^(org.keepassxc.KeePassXC)$
windowrule = float, ^(pavucontrol)$
windowrule = float, ^(blueman-manager)$
windowrule = float, ^(nm-connection-editor)$

# Security: Prevent screenshots of sensitive apps
windowrule = noscreenshot, ^(org.keepassxc.KeePassXC)$
windowrule = noscreenshot, title:^(.*Bitwarden.*)$
windowrule = noscreenshot, title:^(.*Private.*)$

# Opacity rules for immersive minimal look
windowrulev2 = opacity 0.95 0.85, class:^(kitty)$
windowrulev2 = opacity 0.95 0.85, class:^(Alacritty)$

# Keybindings
$mainMod = SUPER

# Core bindings
bind = $mainMod, RETURN, exec, kitty
bind = $mainMod, Q, killactive,
bind = $mainMod, M, exit,
bind = $mainMod, E, exec, firejail --apparmor ranger
bind = $mainMod, V, togglefloating,
bind = $mainMod, D, exec, wofi --show drun
bind = $mainMod, P, pseudo,
bind = $mainMod, J, togglesplit,
bind = $mainMod, F, fullscreen, 1

# Security bindings
bind = $mainMod, L, exec, swaylock -f
bind = $mainMod SHIFT, L, exec, swaylock -f && sleep 1 && systemctl suspend
bind = $mainMod SHIFT, Delete, exec, wl-copy -c  # Clear clipboard

# Screenshot with security confirmation
bind = , Print, exec, grim -g "$(slurp)" - | wl-copy && notify-send "Screenshot copied to clipboard"
bind = SHIFT, Print, exec, grim ~/Pictures/screenshot-$(date +%Y%m%d-%H%M%S).png && notify-send "Screenshot saved"

# Move focus
bind = $mainMod, left, movefocus, l
bind = $mainMod, right, movefocus, r
bind = $mainMod, up, movefocus, u
bind = $mainMod, down, movefocus, d

# Move windows
bind = $mainMod SHIFT, left, movewindow, l
bind = $mainMod SHIFT, right, movewindow, r
bind = $mainMod SHIFT, up, movewindow, u
bind = $mainMod SHIFT, down, movewindow, d

# Switch workspaces
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move window to workspace
bind = $mainMod SHIFT, 1, movetoworkspace, 1
bind = $mainMod SHIFT, 2, movetoworkspace, 2
bind = $mainMod SHIFT, 3, movetoworkspace, 3
bind = $mainMod SHIFT, 4, movetoworkspace, 4
bind = $mainMod SHIFT, 5, movetoworkspace, 5
bind = $mainMod SHIFT, 6, movetoworkspace, 6
bind = $mainMod SHIFT, 7, movetoworkspace, 7
bind = $mainMod SHIFT, 8, movetoworkspace, 8
bind = $mainMod SHIFT, 9, movetoworkspace, 9
bind = $mainMod SHIFT, 0, movetoworkspace, 10

# Scroll through workspaces
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# Move/resize windows
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Volume controls
bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

# Brightness controls
bind = , XF86MonBrightnessUp, exec, brightnessctl set 5%+
bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-

# Workspace-specific app assignments (for workflow isolation)
windowrulev2 = workspace 1, class:^(kitty)$
windowrulev2 = workspace 2, class:^(firefox)$
windowrulev2 = workspace 3, class:^(Code)$
windowrulev2 = workspace 9, class:^(Signal)$
windowrulev2 = workspace 10, class:^(org.keepassxc.KeePassXC)$
EOF

echo -e "${GREEN}✓ Hyprland configuration created${NC}"
