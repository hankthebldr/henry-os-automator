#!/bin/bash
# Terminal Configuration - Kitty with Security Focus

echo "Creating terminal configuration..."

cat > "$HOME/.config/kitty/kitty.conf" << 'EOF'
# Kitty Terminal Configuration
# Minimal, Immersive, Security-Focused

# Font configuration
font_family      JetBrainsMono Nerd Font
bold_font        auto
italic_font      auto
bold_italic_font auto
font_size 11.0

# Cursor
cursor_shape beam
cursor_beam_thickness 1.5
cursor_blink_interval 0

# Scrollback
scrollback_lines 10000
scrollback_pager less --chop-long-lines --RAW-CONTROL-CHARS +INPUT_LINE_NUMBER

# Mouse
mouse_hide_wait 2.0
url_color #88c0d0
url_style curly
detect_urls yes
copy_on_select clipboard

# Performance
repaint_delay 10
input_delay 3
sync_to_monitor yes

# Window layout
window_padding_width 8
window_margin_width 0
placement_strategy center
hide_window_decorations yes
confirm_os_window_close 1

# Tab bar
tab_bar_edge top
tab_bar_style powerline
tab_powerline_style slanted
tab_title_template "{index}: {title}"

# Color scheme - Minimal Dark (Nord-inspired with security focus)
foreground #d8dee9
background #1a1a1a
background_opacity 0.95
dynamic_background_opacity yes

# Security: Dim inactive windows to focus attention
inactive_text_alpha 0.7

# Black
color0 #2e3440
color8 #4c566a

# Red
color1 #bf616a
color9 #d08770

# Green
color2  #a3be8c
color10 #8fbcbb

# Yellow
color3  #ebcb8b
color11 #d8dee9

# Blue
color4  #81a1c1
color12 #88c0d0

# Magenta
color5  #b48ead
color13 #b48ead

# Cyan
color6  #88c0d0
color14 #8fbcbb

# White
color7  #d8dee9
color15 #eceff4

# Selection colors
selection_foreground #1a1a1a
selection_background #88c0d0

# Bell
enable_audio_bell no
visual_bell_duration 0.1
visual_bell_color #bf616a

# Security: Clear terminal on exit
shell_integration no-cursor
close_on_child_death yes

# Keybindings
map ctrl+shift+c copy_to_clipboard
map ctrl+shift+v paste_from_clipboard
map ctrl+shift+s paste_from_selection

map ctrl+shift+up scroll_line_up
map ctrl+shift+down scroll_line_down
map ctrl+shift+home scroll_home
map ctrl+shift+end scroll_end

map ctrl+shift+enter new_window_with_cwd
map ctrl+shift+w close_window
map ctrl+shift+] next_window
map ctrl+shift+[ previous_window

map ctrl+shift+t new_tab_with_cwd
map ctrl+shift+q close_tab
map ctrl+shift+right next_tab
map ctrl+shift+left previous_tab

map ctrl+shift+equal change_font_size all +1.0
map ctrl+shift+minus change_font_size all -1.0
map ctrl+shift+0 change_font_size all 0

map ctrl+shift+f11 toggle_fullscreen

# Security: Disable remote control
allow_remote_control no

# Clipboard security
clipboard_control write-clipboard write-primary read-clipboard read-primary

# Advanced
term xterm-256color
EOF

# Create a secure shell profile
cat > "$HOME/.config/kitty/secure-session.conf" << 'EOF'
# Secure session configuration
# Use: kitty --session secure-session.conf

# Clear environment variables
env HISTFILE=/dev/null
env LESSHISTFILE=/dev/null

# Launch with limited history
launch --cwd=~
EOF

# Swaylock configuration
cat > "$HOME/.config/swaylock/config" << 'EOF'
# Swaylock Configuration - Security Focused

ignore-empty-password
show-failed-attempts
show-keyboard-layout
indicator-caps-lock

# Appearance
color=1a1a1a
bs-hl-color=bf616a
caps-lock-bs-hl-color=d08770
caps-lock-key-hl-color=a3be8c
inside-color=2e3440
inside-clear-color=88c0d0
inside-caps-lock-color=d08770
inside-ver-color=81a1c1
inside-wrong-color=bf616a
key-hl-color=a3be8c
layout-bg-color=1a1a1a
layout-border-color=4c566a
layout-text-color=d8dee9
line-color=1a1a1a
line-clear-color=88c0d0
line-caps-lock-color=d08770
line-ver-color=81a1c1
line-wrong-color=bf616a
ring-color=4c566a
ring-clear-color=88c0d0
ring-caps-lock-color=d08770
ring-ver-color=81a1c1
ring-wrong-color=bf616a
separator-color=1a1a1a
text-color=d8dee9
text-clear-color=1a1a1a
text-caps-lock-color=1a1a1a
text-ver-color=1a1a1a
text-wrong-color=1a1a1a

# Effects
effect-blur=7x5
effect-vignette=0.5:0.5
fade-in=0.2
grace=0
EOF

# Wofi configuration (app launcher)
cat > "$HOME/.config/wofi/config" << 'EOF'
width=600
height=400
location=center
show=drun
prompt=Launch
filter_rate=100
allow_markup=true
no_actions=true
halign=fill
orientation=vertical
content_halign=fill
insensitive=true
allow_images=true
image_size=32
gtk_dark=true
EOF

cat > "$HOME/.config/wofi/style.css" << 'EOF'
window {
    margin: 0px;
    border: 2px solid #4c566a;
    background-color: #1a1a1a;
    border-radius: 8px;
    font-family: "JetBrainsMono Nerd Font", monospace;
    font-size: 14px;
}

#input {
    margin: 8px;
    padding: 8px 12px;
    border: 1px solid #4c566a;
    background-color: #2e3440;
    color: #d8dee9;
    border-radius: 4px;
}

#input:focus {
    border: 1px solid #88c0d0;
}

#inner-box {
    margin: 8px;
    background-color: transparent;
}

#outer-box {
    margin: 0px;
    background-color: transparent;
}

#scroll {
    margin: 0px;
}

#text {
    margin: 4px;
    color: #d8dee9;
}

#entry {
    padding: 6px;
    border-radius: 4px;
}

#entry:selected {
    background-color: #4c566a;
}

#entry:selected #text {
    color: #eceff4;
    font-weight: bold;
}
EOF

# Dunst configuration (notifications)
cat > "$HOME/.config/dunst/dunstrc" << 'EOF'
[global]
    monitor = 0
    follow = mouse
    width = 350
    origin = top-right
    offset = 16x48
    notification_height = 0
    separator_height = 2
    padding = 12
    horizontal_padding = 12
    frame_width = 2
    frame_color = "#4c566a"
    separator_color = frame
    sort = yes
    idle_threshold = 120
    font = JetBrainsMono Nerd Font 10
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    vertical_alignment = center
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    icon_position = left
    min_icon_size = 32
    max_icon_size = 48
    icon_path = /usr/share/icons/Papirus-Dark/48x48/status/:/usr/share/icons/Papirus-Dark/48x48/devices/
    sticky_history = yes
    history_length = 20
    browser = /usr/bin/firefox
    always_run_script = true
    title = Dunst
    class = Dunst
    corner_radius = 8
    timeout = 5

[urgency_low]
    background = "#2e3440"
    foreground = "#d8dee9"
    timeout = 4

[urgency_normal]
    background = "#3b4252"
    foreground = "#d8dee9"
    timeout = 6

[urgency_critical]
    background = "#bf616a"
    foreground = "#eceff4"
    frame_color = "#d08770"
    timeout = 0

# Security notifications
[security]
    appname = security
    urgency = critical
    background = "#bf616a"
    foreground = "#eceff4"
    timeout = 0

[fail2ban]
    appname = fail2ban
    urgency = critical
    timeout = 0
EOF

echo -e "${GREEN}✓ Terminal and application configurations created${NC}"
