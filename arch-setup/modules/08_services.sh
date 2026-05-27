#!/bin/bash
set -e

echo "Setting up System Services (Audio, Bluetooth, Network, Screen Sharing)..."

PACKAGES=(
    pipewire
    wireplumber
    pipewire-audio
    pipewire-alsa
    pipewire-pulse
    pipewire-jack
    pavucontrol
    bluez
    bluez-utils
    blueman
    network-manager-applet
    brightnessctl
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    xwaylandvideobridge
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Enable Bluetooth service
sudo systemctl enable --now bluetooth.service

# Start xwaylandvideobridge automatically on Hyprland startup (if not already there)
if [ -f ~/.config/hypr/configs/exec.conf ]; then
    if ! grep -q "xwaylandvideobridge" ~/.config/hypr/configs/exec.conf; then
        echo "exec-once = xwaylandvideobridge" >> ~/.config/hypr/configs/exec.conf
    fi
fi

# Same for network manager and blueman
if [ -f ~/.config/hypr/configs/exec.conf ]; then
    if ! grep -q "nm-applet" ~/.config/hypr/configs/exec.conf; then
        echo "exec-once = nm-applet --indicator" >> ~/.config/hypr/configs/exec.conf
    fi
    if ! grep -q "blueman-applet" ~/.config/hypr/configs/exec.conf; then
        echo "exec-once = blueman-applet" >> ~/.config/hypr/configs/exec.conf
    fi
fi

echo "System services configured."
