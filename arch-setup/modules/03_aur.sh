#!/bin/bash
set -e

echo "Setting up AUR helper (yay)..."

if command -v yay &> /dev/null; then
    echo "yay is already installed."
    exit 0
fi

# Install dependencies
sudo pacman -S --needed --noconfirm base-devel git

# Build and install yay
TEMP_DIR=$(mktemp -d)
trap "rm -rf '$TEMP_DIR'" EXIT
git clone https://aur.archlinux.org/yay.git "$TEMP_DIR"
cd "$TEMP_DIR"
makepkg -si --noconfirm

echo "yay installed successfully."
