#!/bin/bash
# Keybind List Widget for Stellar Dots
# Shows all Hyprland keybinds in a searchable Rofi menu
# Inspired by end-4/dots-hyprland

# Colors (Rosé Pine theme)
BG="#191724"
FG="#e0def4"
ACCENT="#c4a7e7"
HIGHLIGHT="#eb6f92"

# Parse Hyprland config for keybinds
HYPR_CONFIG="$HOME/.config/hypr/hyprland.conf"

# Function to extract keybinds from config
extract_keybinds() {
    local category=""
    local keybinds=""
    
    # Read hyprland.conf and extract binds
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^[[:space:]]*# ]] && continue
        [[ -z "$line" ]] && continue
        
        # Detect category from comments
        if [[ "$line" =~ ^[[:space:]]*#.*[A-Z] ]]; then
            category=$(echo "$line" | sed 's/^[[:space:]]*#[[:space:]]*//' | sed 's/[[:space:]]*$//')
        fi
        
        # Extract bind lines
        if [[ "$line" =~ ^[[:space:]]*bind[[:space:]]*= ]]; then
            # Parse: bind = SUPER, Q, killactive
            local bind_line=$(echo "$line" | sed 's/^[[:space:]]*bind[[:space:]]*=[[:space:]]*//')
            local modifiers=$(echo "$bind_line" | cut -d',' -f1 | tr -d ' ')
            local key=$(echo "$bind_line" | cut -d',' -f2 | tr -d ' ')
            local action=$(echo "$bind_line" | cut -d',' -f3- | sed 's/^[[:space:]]*//')
            
            # Format keybind
            local formatted_key=$(format_keybind "$modifiers" "$key")
            local description=$(get_action_description "$action")
            
            # Add to list with category
            if [[ -n "$category" ]]; then
                keybinds+="<span foreground='$ACCENT'>[$category]</span> $formatted_key → $description\n"
            else
                keybinds+="$formatted_key → $description\n"
            fi
        fi
    done < "$HYPR_CONFIG"
    
    echo -e "$keybinds"
}

# Format keybind for display
format_keybind() {
    local modifiers="$1"
    local key="$2"
    local result=""
    
    # Replace modifier names
    modifiers=$(echo "$modifiers" | sed 's/SUPER/Super/g')
    modifiers=$(echo "$modifiers" | sed 's/SHIFT/Shift/g')
    modifiers=$(echo "$modifiers" | sed 's/CTRL/Ctrl/g')
    modifiers=$(echo "$modifiers" | sed 's/ALT/Alt/g')
    
    # Combine
    if [[ -n "$modifiers" ]]; then
        result="<span foreground='$HIGHLIGHT'>$modifiers</span> + <b>$key</b>"
    else
        result="<b>$key</b>"
    fi
    
    echo "$result"
}

# Get human-readable description for action
get_action_description() {
    local action="$1"
    
    case "$action" in
        *"killactive"*) echo "Close window" ;;
        *"exec,kitty"*|*"exec, kitty"*) echo "Open terminal" ;;
        *"togglefloating"*) echo "Toggle floating" ;;
        *"fullscreen"*) echo "Toggle fullscreen" ;;
        *"workspace,"*) echo "Switch workspace" ;;
        *"movetoworkspace"*) echo "Move to workspace" ;;
        *"pseudo"*) echo "Toggle pseudo tiling" ;;
        *"togglesplit"*) echo "Toggle split" ;;
        *"movefocus"*) echo "Move focus" ;;
        *"movewindow"*) echo "Move window" ;;
        *"resizeactive"*) echo "Resize window" ;;
        *"app-menu"*) echo "App launcher" ;;
        *"power-menu"*) echo "Power menu" ;;
        *"wallpaper"*) echo "Change wallpaper" ;;
        *"theme-switcher"*) echo "Change theme" ;;
        *"screenshot"*) echo "Screenshot" ;;
        *"grim"*) echo "Screenshot" ;;
        *"clipboard"*) echo "Clipboard manager" ;;
        *"emoji"*) echo "Emoji picker" ;;
        *"network"*) echo "Network manager" ;;
        *"bluetooth"*) echo "Bluetooth manager" ;;
        *"hyprlock"*) echo "Lock screen" ;;
        *) echo "$action" ;;
    esac
}

# Create Rofi config for keybind display
create_rofi_config() {
    cat > /tmp/keybind-rofi.rasi <<EOF
configuration {
    modi: "drun";
    show-icons: false;
    display-drun: "Keybinds";
}

* {
    bg: $BG;
    fg: $FG;
    accent: $ACCENT;
    highlight: $HIGHLIGHT;
    
    background-color: @bg;
    text-color: @fg;
    
    border: 2px;
    border-color: @accent;
    border-radius: 12px;
}

window {
    width: 800px;
    padding: 20px;
}

mainbox {
    children: [inputbar, listview];
    spacing: 20px;
}

inputbar {
    children: [prompt, entry];
    spacing: 10px;
    padding: 10px;
    background-color: rgba(255, 255, 255, 0.05);
    border-radius: 8px;
}

prompt {
    text-color: @accent;
    font: "JetBrainsMono Nerd Font Bold 12";
}

entry {
    placeholder: "Search keybinds...";
    placeholder-color: rgba(224, 222, 244, 0.5);
}

listview {
    lines: 15;
    scrollbar: true;
}

element {
    padding: 8px;
    border-radius: 6px;
}

element selected {
    background-color: @accent;
    text-color: @bg;
}

element-text {
    markup: true;
}

scrollbar {
    handle-color: @accent;
    handle-width: 4px;
}
EOF
}

# Main function
main() {
    # Check if Hyprland config exists
    if [[ ! -f "$HYPR_CONFIG" ]]; then
        notify-send "Keybind List" "Hyprland config not found!" -u critical
        exit 1
    fi
    
    # Create Rofi config
    create_rofi_config
    
    # Extract keybinds
    keybinds=$(extract_keybinds)
    
    # Show in Rofi
    echo -e "$keybinds" | rofi -dmenu \
        -markup-rows \
        -theme /tmp/keybind-rofi.rasi \
        -p "Keybinds" \
        -mesg "Press <b>Super + /</b> to show this menu anytime"
    
    # Cleanup
    rm -f /tmp/keybind-rofi.rasi
}

main
