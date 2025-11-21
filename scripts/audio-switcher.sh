#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                       🔊 AUDIO SWITCHER 🔊                                ║
# ║                        Stellar Dots Utility                                ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

# Check if pactl is available
if ! command -v pactl &> /dev/null; then
    notify-send "Audio Switcher" "PulseAudio/PipeWire não está instalado!" -u critical
    exit 1
fi

# Get current default sink
current_sink=$(pactl get-default-sink)

# Get list of sinks
sinks=$(pactl list short sinks | awk '{print $2}')

# Build menu with current sink marked
menu=""
while IFS= read -r sink; do
    # Get sink description
    desc=$(pactl list sinks | grep -A 20 "Name: $sink" | grep "Description:" | cut -d: -f2- | sed 's/^[ \t]*//')
    
    if [ "$sink" = "$current_sink" ]; then
        menu+="✓ $desc\n"
    else
        menu+="  $desc\n"
    fi
done <<< "$sinks"

# Show menu
chosen=$(echo -e "$menu" | rofi -dmenu -p "Audio Output" -theme ~/.config/rofi/audio.rasi)

if [ -n "$chosen" ]; then
    # Remove checkmark if present
    chosen=$(echo "$chosen" | sed 's/^[✓ ]*//')
    
    # Find sink by description
    new_sink=$(pactl list sinks | grep -B 20 "Description: $chosen" | grep "Name:" | head -1 | awk '{print $2}')
    
    if [ -n "$new_sink" ]; then
        # Set as default sink
        pactl set-default-sink "$new_sink"
        
        # Move all current streams to new sink
        pactl list short sink-inputs | awk '{print $1}' | while read -r stream; do
            pactl move-sink-input "$stream" "$new_sink" 2>/dev/null
        done
        
        notify-send "Audio" "Saída alterada para: $chosen" -i audio-speakers
    fi
fi
