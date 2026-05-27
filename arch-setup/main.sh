#!/bin/bash

# YARICK Arch Linux Setup Script
# Author: Gemini CLI
# Date: 2026-05-27

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
STATE_FILE="$SCRIPT_DIR/.install_state"
MODULES_DIR="$SCRIPT_DIR/modules"

log() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Check if state file exists, if not create it
if [ ! -f "$STATE_FILE" ]; then
    touch "$STATE_FILE"
fi

is_step_done() {
    grep -q "^$1$" "$STATE_FILE"
}

mark_step_done() {
    echo "$1" >> "$STATE_FILE"
}

# Header
echo -e "${BLUE}"
echo " __  __   _    ___ ___ ___ _  __  _         _        _ _ "
echo " \ \/ /  / \  | _ \_ _/ __| |/ / (_)_ _  __| |_ __ _| | |"
echo "  \  /  / _ \ |   /| | (__| ' <  | | ' \/ _\` |/ _\` | | |"
echo "  /_/  /_/ \_\|_|_\___\___|_|\_\ |_|_||_\__,_|\__,_|_|_|"
echo "                                                         "
echo -e "${NC}"
echo "Welcome to the YARICK Arch Setup!"
echo "----------------------------------------"

# Sudo persistence: Ask for password once and keep it alive
echo "Please provide sudo password to initialize persistent session."
sudo -v
if [ $? -ne 0 ]; then
    error "Sudo authentication failed. Exiting."
    exit 1
fi

# Keep-alive sudo session in the background
(while true; do sudo -n v; sleep 60; kill -0 "$$" || exit; done) 2>/dev/null &

# Function to ask for confirmation
confirm() {
    read -rp "$1 (Y/n): " choice
    case "$choice" in 
      n|N ) return 1;;
      * ) return 0;;
    esac
}

# Modules to run
MODULES=(
    "01_mirrors.sh"
    "02_nvidia.sh"
    "03_aur.sh"
    "04_hyprland.sh"
    "05_apps.sh"
    "06_docker.sh"
    "07_theme.sh"
    "08_services.sh"
    "09_terminal.sh"
    "10_neovim.sh"
)

echo "Ready to begin the installation. You can choose which steps to run."

for module in "${MODULES[@]}"; do
    module_path="$MODULES_DIR/$module"
    module_name=$(basename "$module" .sh)
    
    if is_step_done "$module_name"; then
        log "Step $module_name is already marked as completed. Skipping..."
        continue
    fi
    
    if confirm "Run step: $module_name?"; then
        echo -e "\n${YELLOW}>>> Running $module_name...${NC}"
        if [ -f "$module_path" ]; then
            # Run module and capture exit code
            if bash "$module_path"; then
                mark_step_done "$module_name"
                success "$module_name completed successfully."
            else
                error "Step $module_name failed."
                if ! confirm "Do you want to continue to the next step anyway?"; then
                    error "Installation aborted by user."
                    exit 1
                fi
            fi
        else
            error "Module $module_path not found!"
            if ! confirm "Skip this missing module and continue?"; then
                exit 1
            fi
        fi
    else
        log "Skipping $module_name."
    fi
done

success "All selected installation steps processed. Please reboot your system."
