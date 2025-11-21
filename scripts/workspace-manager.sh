#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                     🗂️ WORKSPACE MANAGER 🗂️                              ║
# ║                    Stellar Dots Productivity Tool                          ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Get current workspace
current_workspace=$(hyprctl activeworkspace -j | jq -r '.id')

# Workspace presets
workspaces="1️⃣ Workspace 1 - Main
2️⃣ Workspace 2 - Browser
3️⃣ Workspace 3 - Code
4️⃣ Workspace 4 - Terminal
5️⃣ Workspace 5 - Files
6️⃣ Workspace 6 - Media
7️⃣ Workspace 7 - Chat
8️⃣ Workspace 8 - Gaming
9️⃣ Workspace 9 - Misc
──────────────
📋 Atual: Workspace $current_workspace"

# Show menu
chosen=$(echo -e "$workspaces" | rofi -dmenu -p "Workspace Manager" -theme ~/.config/rofi/power-menu.rasi)

# Extract workspace number
if [[ "$chosen" =~ ^([0-9])️⃣ ]]; then
    workspace="${BASH_REMATCH[1]}"
    hyprctl dispatch workspace "$workspace"
    notify-send "Workspace" "Mudou para Workspace $workspace" -i preferences-desktop-display
fi
