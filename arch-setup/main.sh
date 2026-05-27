#!/bin/bash

set -e

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
  echo "$1" >>"$STATE_FILE"
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

# Check for sudo
if [[ $EUID -ne 0 ]]; then
   echo "This script will ask for your password for sudo tasks."
fi

# Function to ask for confirmation
confirm() {
    read -p "$1 (Y/n): " choice
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
    log "Step $module_name is already marked as completed in state file. Skipping..."
    continue
  fi

  if confirm "Run step: $module_name?"; then
    echo -e "\n${YELLOW}>>> Running $module_name...${NC}"
    if [ -f "$module_path" ]; then
      bash "$module_path"
      mark_step_done "$module_name"
      success "$module_name completed!"
    else
      error "Module $module_path not found!"
      exit 1
    fi
  else
    log "Skipping $module_name."
  fi
done

success "All installation steps completed! Please reboot your system."
