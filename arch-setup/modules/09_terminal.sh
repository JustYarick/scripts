#!/bin/bash
set -e

echo "Setting up professional terminal environment (Zsh + Tmux)..."

# 1. Install required packages
PACKAGES=(
    zsh
    tmux
    ttf-jetbrains-mono-nerd
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf
    bat
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# 2. Setup Zsh (Oh My Zsh + Powerlevel10k)
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install Powerlevel10k theme
P10K_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"
if [ ! -d "$P10K_DIR" ]; then
    echo "Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# Configure .zshrc
cat > ~/.zshrc <<EOF
# Zsh Configuration
export ZSH="\$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
    git
    docker
    docker-compose
    sudo
    fzf
)

source \$ZSH/oh-my-zsh.sh

# User plugins (installed via pacman)
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias cat='bat' # If you install 'bat' later
alias top='btop'

# P10K instant prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
EOF

# 3. Setup Tmux (Production ready)
cat > ~/.tmux.conf <<EOF
# Tmux Configuration

# Quality of Life
set -g history-limit 10000
set -g mouse on
set -g base-index 1
setw -g pane-base-index 1

# Renaming
set -g allow-rename off
set -g set-titles on

# Keybindings
# Use Alt-arrow keys to switch panes
bind -n M-Left select-pane -l
bind -n M-Right select-pane -r
bind -n M-Up select-pane -u
bind -n M-Down select-pane -d

# Status bar
set -g status-bg black
set -g status-fg white
set -g status-interval 5
set -g status-left-length 30
set -g status-left '#[fg=green](#S) #(whoami)'
set -g status-right '#[fg=yellow]#(cut -d " " -f 1-3 /proc/loadavg) #[fg=white]%H:%M:%S#[default]'

# Fix color issues in terminal
set -g default-terminal "screen-256color"
EOF

# 4. Set Zsh as default shell
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "Changing default shell to zsh..."
    sudo chsh -s /usr/bin/zsh "$USER"
fi

echo "Terminal setup complete. Please restart your terminal or log out/in."
