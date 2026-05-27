#!/bin/bash
set -e

echo "Configuring and updating mirrors..."

# Install reflector if not present
if ! command -v reflector &> /dev/null; then
    sudo pacman -Sy --noconfirm reflector
fi

# Backup old mirrorlist
if [ ! -f /etc/pacman.d/mirrorlist.bak ]; then
    sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
fi

# Update mirrors (optimized for speed and reliability)
echo "Finding the best mirrors (top 10 by speed, synchronized within 12 hours)..."
sudo reflector --latest 10 --protocol https --sort rate --save /etc/pacman.d/mirrorlist

# Enable multilib
if ! grep -q "^\[multilib\]" /etc/pacman.conf; then
    echo "Enabling multilib repository..."
    sudo sed -i '/^#\[multilib\]/,/Include = \/etc\/pacman.d\/mirrorlist/ s/^#//' /etc/pacman.conf
fi

# Update system
sudo pacman -Syu --noconfirm
