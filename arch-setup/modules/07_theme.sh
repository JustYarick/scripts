#!/bin/bash
set -e

echo "Setting up Themes (Waybar, Rofi)..."

# Ensure configs exist
mkdir -p ~/.config/waybar
mkdir -p ~/.config/rofi

# Waybar config (Simple, clean, production ready)
cat > ~/.config/waybar/config <<EOF
{
    "layer": "top",
    "position": "top",
    "height": 30,
    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["hyprland/window"],
    "modules-right": ["pulseaudio", "network", "battery", "clock", "tray"],
    "hyprland/workspaces": {
        "disable-scroll": true,
        "all-outputs": true,
        "format": "{name}"
    },
    "clock": {
        "format": "{:%a, %d. %b  %H:%M}"
    },
    "pulseaudio": {
        "format": "{volume}% {icon}",
        "format-bluetooth": "{volume}% {icon}",
        "format-muted": "",
        "format-icons": {
            "default": ["", ""]
        },
        "scroll-step": 1,
        "on-click": "pavucontrol"
    },
    "network": {
        "format-wifi": "{essid} ",
        "format-ethernet": "{ipaddr}/{cidr} ",
        "tooltip-format": "{ifname} via {gwaddr} ",
        "format-linked": "{ifname} (No IP) ",
        "format-disconnected": "Disconnected ⚠",
        "format-alt": "{ifname}: {ipaddr}/{cidr}"
    },
    "tray": {
        "icon-size": 18,
        "spacing": 10
    }
}
EOF

# Waybar CSS
cat > ~/.config/waybar/style.css <<EOF
* {
    border: none;
    border-radius: 0;
    font-family: "JetBrainsMono Nerd Font", "Font Awesome 5 Free", sans-serif;
    font-size: 14px;
    min-height: 0;
}
window#waybar {
    background: rgba(30, 30, 46, 0.8);
    color: #cdd6f4;
}
#workspaces button {
    padding: 0 10px;
    color: #cdd6f4;
}
#workspaces button.active {
    background: #89b4fa;
    color: #1e1e2e;
}
#clock, #battery, #cpu, #memory, #network, #pulseaudio, #tray, #mode {
    padding: 0 10px;
    margin: 0 5px;
}
EOF

# Rofi config (Clean style)
cat > ~/.config/rofi/config.rasi <<EOF
configuration {
    modi: "drun,run";
    show-icons: true;
    font: "JetBrainsMono Nerd Font 12";
}
@theme "Monokai"
EOF

echo "Themes configured."
