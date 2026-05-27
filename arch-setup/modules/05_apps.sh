#!/bin/bash
set -e

echo "Installing requested applications..."

# Pacman packages
PACMAN_APPS=(
    firefox
    telegram-desktop
    discord
    steam
    btop
    nautilus
)

# AUR packages
AUR_APPS=(
    google-chrome
    v2ray-bin
    throne-bin
    teamspeak3
    onlyoffice-bin
)

echo "Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACMAN_APPS[@]}"

echo "Installing AUR packages..."
yay -S --needed --noconfirm "${AUR_APPS[@]}"

echo "Applications installed."
