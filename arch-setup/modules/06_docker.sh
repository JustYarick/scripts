#!/bin/bash
set -e

echo "Installing and configuring Docker..."

# Install docker and docker-compose
sudo pacman -S --needed --noconfirm docker docker-compose

# Start and enable docker service
sudo systemctl enable --now docker.service

# Add current user to docker group
if ! groups $USER | grep -q "\bdocker\b"; then
    echo "Adding $USER to the docker group..."
    sudo usermod -aG docker $USER
    echo "Note: You may need to log out and log back in for docker group changes to take effect."
fi

echo "Docker installation and configuration complete."
