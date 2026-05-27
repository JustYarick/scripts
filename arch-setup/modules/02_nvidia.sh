#!/bin/bash
set -e

echo "Detecting NVIDIA hardware..."

GPU_INFO=$(lspci | grep -i nvidia || true)

if [ -z "$GPU_INFO" ]; then
    echo "No NVIDIA GPU detected. Skipping NVIDIA driver installation."
    exit 0
fi

echo "NVIDIA GPU detected: $GPU_INFO"

# Check if drivers are already installed
if pacman -Qs nvidia &> /dev/null; then
    echo "NVIDIA drivers appear to be already installed."
    read -rp "Do you want to reinstall/update them? (y/N): " choice
    if [[ ! "$choice" =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

echo "Installing NVIDIA proprietary drivers for Wayland/Hyprland..."
sudo pacman -S --noconfirm nvidia nvidia-utils nvidia-settings lib32-nvidia-utils

# Enable DRM modesetting
echo "Enabling DRM modesetting..."
if ! grep -q "nvidia-drm.modeset=1" /etc/default/grub; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="nvidia-drm.modeset=1 /' /etc/default/grub
    if command -v grub-mkconfig &> /dev/null; then
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
fi

# Add nvidia modules to mkinitcpio
if ! grep -q "nvidia nvidia_modeset nvidia_uvm nvidia_drm" /etc/mkinitcpio.conf; then
    sudo sed -i 's/MODULES=(/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm /' /etc/mkinitcpio.conf
    sudo mkinitcpio -P
fi

# Create nvidia.conf for modprobe
echo "options nvidia-drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf > /dev/null

echo "NVIDIA drivers installed. A reboot is recommended after the full script finishes."
