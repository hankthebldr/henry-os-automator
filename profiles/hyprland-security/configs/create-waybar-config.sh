#!/bin/bash
# Waybar Configuration - Minimal & Immersive

echo "Creating Waybar configuration..."

cat > "$HOME/.config/waybar/config" << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 32,
    "spacing": 8,

    "modules-left": ["hyprland/workspaces", "hyprland/window"],
    "modules-center": ["clock"],
    "modules-right": ["privacy", "network", "cpu", "memory", "pulseaudio", "battery", "tray"],

    "hyprland/workspaces": {
        "disable-scroll": false,
        "all-outputs": true,
        "format": "{icon}",
        "format-icons": {
            "1": "󰖟",
            "2": "󰈹",
            "3": "󰨞",
            "4": "󰎄",
            "5": "󰊢",
            "9": "󰍡",
            "10": "󰌾",
            "urgent": "",
            "focused": "",
            "default": "󰧞"
        },
        "persistent_workspaces": {
            "1": [],
            "2": [],
            "3": [],
            "4": [],
            "5": []
        }
    },

    "hyprland/window": {
        "format": "{}",
        "max-length": 50,
        "separate-outputs": true,
        "rewrite": {
            "(.*) — Mozilla Firefox": "󰈹 $1",
            "(.*)Mozilla Firefox": "󰈹 Firefox",
            "(.*) - Visual Studio Code": "󰨞 $1",
            "(.*)Visual Studio Code": "󰨞 Code"
        }
    },

    "clock": {
        "timezone": "UTC",
        "format": "{:%H:%M %Z}",
        "format-alt": "{:%Y-%m-%d %H:%M:%S}",
        "tooltip-format": "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>",
        "on-click": "",
        "interval": 1
    },

    "privacy": {
        "icon-spacing": 4,
        "icon-size": 18,
        "transition-duration": 250,
        "modules": [
            {
                "type": "screenshare",
                "tooltip": true,
                "tooltip-icon-size": 24
            },
            {
                "type": "audio-in",
                "tooltip": true,
                "tooltip-icon-size": 24
            }
        ]
    },

    "cpu": {
        "interval": 2,
        "format": "󰍛 {usage}%",
        "max-length": 10,
        "on-click": "kitty -e btop"
    },

    "memory": {
        "interval": 5,
        "format": "󰘚 {percentage}%",
        "max-length": 10,
        "tooltip-format": "RAM: {used:0.1f}G / {total:0.1f}G\nSwap: {swapUsed:0.1f}G / {swapTotal:0.1f}G",
        "on-click": "kitty -e btop"
    },

    "network": {
        "format-wifi": "󰖩 {essid}",
        "format-ethernet": "󰈀 {ipaddr}",
        "format-linked": "󰈀 {ifname} (No IP)",
        "format-disconnected": "󰖪 Disconnected",
        "tooltip-format": "{ifname}: {ipaddr}/{cidr}\nUp: {bandwidthUpBytes} Down: {bandwidthDownBytes}",
        "on-click": "nm-connection-editor",
        "interval": 5
    },

    "pulseaudio": {
        "format": "{icon} {volume}%",
        "format-bluetooth": "{icon}󰂯 {volume}%",
        "format-muted": "󰖁",
        "format-icons": {
            "headphone": "󰋋",
            "hands-free": "󰋋",
            "headset": "󰋋",
            "phone": "",
            "portable": "",
            "car": "",
            "default": ["󰕿", "󰖀", "󰕾"]
        },
        "on-click": "pavucontrol",
        "on-click-right": "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle",
        "scroll-step": 5
    },

    "battery": {
        "states": {
            "warning": 30,
            "critical": 15
        },
        "format": "{icon} {capacity}%",
        "format-charging": "󰂄 {capacity}%",
        "format-plugged": "󰚥 {capacity}%",
        "format-icons": ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"],
        "tooltip-format": "{timeTo}\nPower: {power}W"
    },

    "tray": {
        "icon-size": 18,
        "spacing": 8
    }
}
EOF

cat > "$HOME/.config/waybar/style.css" << 'EOF'
/* Waybar Style - Minimal Dark Security Theme */

* {
    font-family: "JetBrainsMono Nerd Font", "Fira Code", monospace;
    font-size: 13px;
    font-weight: 500;
    min-height: 0;
}

window#waybar {
    background-color: rgba(20, 20, 20, 0.9);
    border-bottom: 2px solid rgba(80, 80, 80, 0.5);
    color: #e0e0e0;
    transition-property: background-color;
    transition-duration: 0.3s;
    backdrop-filter: blur(10px);
}

window#waybar.hidden {
    opacity: 0.2;
}

#workspaces {
    margin: 0 8px;
}

#workspaces button {
    padding: 0 8px;
    background-color: transparent;
    color: #666;
    border: none;
    border-radius: 4px;
    transition: all 0.3s ease;
}

#workspaces button:hover {
    background-color: rgba(80, 80, 80, 0.3);
    color: #e0e0e0;
}

#workspaces button.active {
    background-color: rgba(100, 100, 100, 0.4);
    color: #ffffff;
    font-weight: bold;
}

#workspaces button.urgent {
    background-color: rgba(200, 50, 50, 0.5);
    color: #ff6b6b;
    animation: blink 1s ease infinite;
}

@keyframes blink {
    0%, 100% { opacity: 1; }
    50% { opacity: 0.5; }
}

#window {
    margin: 0 12px;
    color: #d0d0d0;
    font-weight: 500;
}

#clock {
    padding: 0 16px;
    color: #e0e0e0;
    font-weight: 600;
    font-size: 14px;
    background-color: rgba(40, 40, 40, 0.5);
    border-radius: 4px;
}

#privacy {
    padding: 0 8px;
    margin: 0 4px;
}

#privacy-item {
    padding: 0 4px;
    color: #ff6b6b;
}

#privacy-item.screenshare {
    background-color: rgba(200, 50, 50, 0.3);
    border-radius: 4px;
}

#privacy-item.audio-in {
    background-color: rgba(200, 100, 50, 0.3);
    border-radius: 4px;
}

#cpu,
#memory,
#network,
#pulseaudio,
#battery,
#tray {
    padding: 0 12px;
    margin: 0 2px;
    border-radius: 4px;
    background-color: rgba(40, 40, 40, 0.4);
}

#cpu {
    color: #81a1c1;
}

#cpu:hover {
    background-color: rgba(60, 80, 100, 0.4);
}

#memory {
    color: #a3be8c;
}

#memory:hover {
    background-color: rgba(80, 100, 60, 0.4);
}

#network {
    color: #88c0d0;
}

#network.disconnected {
    color: #bf616a;
    background-color: rgba(150, 50, 50, 0.3);
}

#pulseaudio {
    color: #ebcb8b;
}

#pulseaudio.muted {
    color: #666;
}

#battery {
    color: #a3be8c;
}

#battery.charging {
    color: #8fbcbb;
}

#battery.warning:not(.charging) {
    color: #ebcb8b;
    background-color: rgba(150, 120, 50, 0.3);
}

#battery.critical:not(.charging) {
    color: #bf616a;
    background-color: rgba(150, 50, 50, 0.3);
    animation: blink 0.5s ease infinite;
}

#tray {
    padding: 0 8px;
}

#tray > .passive {
    opacity: 0.6;
}

#tray > .needs-attention {
    background-color: rgba(200, 50, 50, 0.3);
    border-radius: 4px;
}

tooltip {
    background-color: rgba(30, 30, 30, 0.95);
    border: 1px solid rgba(80, 80, 80, 0.5);
    border-radius: 6px;
    padding: 8px;
}

tooltip label {
    color: #e0e0e0;
}
EOF

echo -e "${GREEN}✓ Waybar configuration created${NC}"
