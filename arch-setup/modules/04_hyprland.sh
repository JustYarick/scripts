#!/bin/bash
set -e

echo "Installing Hyprland and core desktop components..."

# Core desktop packages
PACKAGES=(
  hyprland
  waybar
  rofi-wayland
  swww
  dunst
  libnotify
  xdg-desktop-portal-hyprland
  qt5-wayland
  qt6-wayland
  polkit-kde-agent
  grim
  slurp
  wl-clipboard
  nautilus
  ttf-font-awesome
  noto-fonts
  noto-fonts-emoji
)

sudo pacman -S --needed --noconfirm "${PACKAGES[@]}"

# Install Ghostty from AUR if not present
if ! command -v ghostty &>/dev/null; then
  echo "Installing Ghostty from AUR..."
  yay -S --noconfirm ghostty
fi

# Create config directories
CONFIG_DIR="$HOME/.config/hypr"
mkdir -p "$CONFIG_DIR/configs"
mkdir -p ~/.config/waybar
mkdir -p ~/.config/rofi

# Monitor Selection
echo "------------------------------------------"
echo "Monitor Configuration"
echo "1) Single Monitor"
echo "2) Dual Monitor (Split Workspaces: 1-10 and 11-20)"
read -rp "Select your setup (1/2): " MON_SETUP

echo "Generating modular Hyprland configuration..."

# 1. Main hyprland.conf
cat >"$CONFIG_DIR/hyprland.conf" <<EOF
# Omarchy-style Modular Hyprland Config
source = ~/.config/hypr/configs/monitors.conf
source = ~/.config/hypr/configs/exec.conf
source = ~/.config/hypr/configs/input.conf
source = ~/.config/hypr/configs/appearance.conf
source = ~/.config/hypr/configs/keybinds.conf
source = ~/.config/hypr/configs/windowrules.conf
EOF

# 2. Monitors & Workspace Binding
if [ "$MON_SETUP" == "2" ]; then
  cat >"$CONFIG_DIR/configs/monitors.conf" <<EOF
# Dual Monitor Configuration (Split)
monitor=eDP-1,preferred,auto,1
monitor=DP-1,preferred,auto,1

# Primary Monitor (Workspaces 1-10)
workspace = 1, monitor:eDP-1
workspace = 2, monitor:eDP-1
workspace = 3, monitor:eDP-1
workspace = 4, monitor:eDP-1
workspace = 5, monitor:eDP-1
workspace = 6, monitor:eDP-1
workspace = 7, monitor:eDP-1
workspace = 8, monitor:eDP-1
workspace = 9, monitor:eDP-1
workspace = 10, monitor:eDP-1

# Secondary Monitor (Workspaces 11-20)
workspace = 11, monitor:DP-1
workspace = 12, monitor:DP-1
workspace = 13, monitor:DP-1
workspace = 14, monitor:DP-1
workspace = 15, monitor:DP-1
workspace = 16, monitor:DP-1
workspace = 17, monitor:DP-1
workspace = 18, monitor:DP-1
workspace = 19, monitor:DP-1
workspace = 20, monitor:DP-1
EOF
else
  cat >"$CONFIG_DIR/configs/monitors.conf" <<EOF
# Single Monitor Configuration
monitor=,preferred,auto,1
EOF
fi

# 3. Exec (Auto-start)
cat >"$CONFIG_DIR/configs/exec.conf" <<EOF
# Auto-start Applications
exec-once = waybar
exec-once = swww init
exec-once = dunst
exec-once = nm-applet --indicator
exec-once = blueman-applet
exec-once = xwaylandvideobridge
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
EOF

# 4. Input
cat >"$CONFIG_DIR/configs/input.conf" <<EOF
input {
    kb_layout = us,ru
    kb_options = grp:alt_shift_toggle
    follow_mouse = 1
    touchpad { natural_scroll = yes }
    sensitivity = 0
}
gestures { workspace_swipe = on }
EOF

# 5. Appearance
cat >"$CONFIG_DIR/configs/appearance.conf" <<EOF
general {
    gaps_in = 5
    gaps_out = 10
    border_size = 2
    col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    col.inactive_border = rgba(595959aa)
    layout = dwindle
}
decoration {
    rounding = 10
    blur { enabled = true; size = 3; passes = 1 }
    drop_shadow = yes; shadow_range = 4; shadow_render_power = 3; col.shadow = rgba(1a1a1aee)
}
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}
dwindle { pseudotile = yes; preserve_split = yes }
EOF

# 6. Keybinds
BIND_FILE="$CONFIG_DIR/configs/keybinds.conf"
cat >"$BIND_FILE" <<EOF
\$mainMod = SUPER

# Applications
bind = \$mainMod, RETURN, exec, ghostty
bind = \$mainMod, SPACE, exec, rofi -show drun
bind = \$mainMod, B, exec, firefox
bind = \$mainMod SHIFT, F, exec, nautilus
bind = \$mainMod SHIFT, T, exec, ghostty -e btop

# Window Management
bind = \$mainMod, W, killactive, 
bind = \$mainMod, M, exit, 
bind = \$mainMod, T, togglefloating, 
bind = \$mainMod, F, fullscreen,
bind = \$mainMod, G, togglesplit,

# Focus
bind = \$mainMod, H, movefocus, l
bind = \$mainMod, L, movefocus, r
bind = \$mainMod, K, movefocus, u
bind = \$mainMod, J, movefocus, d

# --- Workspaces ---

# Monitor 1 (Main: 1-10)
bind = \$mainMod, 1, workspace, 1
bind = \$mainMod, 2, workspace, 2
bind = \$mainMod, 3, workspace, 3
bind = \$mainMod, 4, workspace, 4
bind = \$mainMod, 5, workspace, 5
bind = \$mainMod, 6, workspace, 6
bind = \$mainMod, 7, workspace, 7
bind = \$mainMod, 8, workspace, 8
bind = \$mainMod, 9, workspace, 9
bind = \$mainMod, 0, workspace, 10

bind = \$mainMod SHIFT, 1, movetoworkspace, 1
bind = \$mainMod SHIFT, 2, movetoworkspace, 2
bind = \$mainMod SHIFT, 3, movetoworkspace, 3
bind = \$mainMod SHIFT, 4, movetoworkspace, 4
bind = \$mainMod SHIFT, 5, movetoworkspace, 5
bind = \$mainMod SHIFT, 6, movetoworkspace, 6
bind = \$mainMod SHIFT, 7, movetoworkspace, 7
bind = \$mainMod SHIFT, 8, movetoworkspace, 8
bind = \$mainMod SHIFT, 9, movetoworkspace, 9
bind = \$mainMod SHIFT, 0, movetoworkspace, 10
EOF

if [ "$MON_SETUP" == "2" ]; then
  cat >>"$BIND_FILE" <<EOF

# Monitor 2 (Secondary: 11-20)
bind = \$mainMod ALT, 1, workspace, 11
bind = \$mainMod ALT, 2, workspace, 12
bind = \$mainMod ALT, 3, workspace, 13
bind = \$mainMod ALT, 4, workspace, 14
bind = \$mainMod ALT, 5, workspace, 15
bind = \$mainMod ALT, 6, workspace, 16
bind = \$mainMod ALT, 7, workspace, 17
bind = \$mainMod ALT, 8, workspace, 18
bind = \$mainMod ALT, 9, workspace, 19
bind = \$mainMod ALT, 0, workspace, 20

bind = \$mainMod SHIFT ALT, 1, movetoworkspace, 11
bind = \$mainMod SHIFT ALT, 2, movetoworkspace, 12
bind = \$mainMod SHIFT ALT, 3, movetoworkspace, 13
bind = \$mainMod SHIFT ALT, 4, movetoworkspace, 14
bind = \$mainMod SHIFT ALT, 5, movetoworkspace, 15
bind = \$mainMod SHIFT ALT, 6, movetoworkspace, 16
bind = \$mainMod SHIFT ALT, 7, movetoworkspace, 17
bind = \$mainMod SHIFT ALT, 8, movetoworkspace, 18
bind = \$mainMod SHIFT ALT, 9, movetoworkspace, 19
bind = \$mainMod SHIFT ALT, 0, movetoworkspace, 20
EOF
fi

cat >>"$BIND_FILE" <<EOF

# Mouse
bindm = \$mainMod, mouse:272, movewindow
bindm = \$mainMod, mouse:273, resizewindow
EOF

# 7. Window Rules
cat >"$CONFIG_DIR/configs/windowrules.conf" <<EOF
windowrulev2 = float,class:^(org.gnome.Nautilus)$
windowrulev2 = float,class:^(pavucontrol)$
windowrulev2 = float,class:^(blueman-manager)$
windowrulev2 = float,class:^(org.kde.polkit-kde-authentication-agent-1)$
EOF

echo "Modular Hyprland configuration with Split Dual-Monitor support applied."
