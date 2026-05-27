#!/bin/bash
set -e

echo "Setting up Neovim with LazyVim..."

# Install Neovim and dependencies for LazyVim (telescope, parsers, etc)
PACKAGES=(
    neovim
    git
    base-devel
    fd
    ripgrep
    lazygit
    nodejs
    npm
    python
    python-pip
    unzip
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Backup existing config if it exists
if [ -d ~/.config/nvim ]; then
    echo "Backing up existing ~/.config/nvim to ~/.config/nvim.bak..."
    mv ~/.config/nvim ~/.config/nvim.bak
fi

# Backup existing local data if it exists
if [ -d ~/.local/share/nvim ]; then
    mv ~/.local/share/nvim ~/.local/share/nvim.bak
fi
if [ -d ~/.local/state/nvim ]; then
    mv ~/.local/state/nvim ~/.local/state/nvim.bak
fi
if [ -d ~/.cache/nvim ]; then
    mv ~/.cache/nvim ~/.cache/nvim.bak
fi

# Clone LazyVim starter
echo "Cloning LazyVim starter..."
git clone https://github.com/LazyVim/starter ~/.config/nvim

# Remove the .git folder so you can add it to your own repo later
rm -rf ~/.config/nvim/.git

echo "Neovim and LazyVim setup complete! Open 'nvim' to let LazyVim install plugins."
