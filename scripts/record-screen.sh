#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                      ✨ SCREEN RECORDER SCRIPT ✨                          ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

RECORDING_DIR="$HOME/Videos/recordings"
mkdir -p "$RECORDING_DIR"

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FILENAME="$RECORDING_DIR/recording_$TIMESTAMP.mp4"
PID_FILE="/tmp/wf-recorder.pid"

# Check if already recording
if [[ -f "$PID_FILE" ]]; then
    # Stop recording
    kill -INT $(cat "$PID_FILE")
    rm "$PID_FILE"
    notify-send "Screen Recorder" "Gravação finalizada!"
    echo "✓ Gravação salva: $FILENAME"
else
    # Start recording
    notify-send "Screen Recorder" "Iniciando gravação..."
    
    # Select area or full screen
    if [[ "$1" == "--area" ]]; then
        geometry=$(slurp)
        wf-recorder -g "$geometry" -f "$FILENAME" &
    else
        wf-recorder -f "$FILENAME" &
    fi
    
    echo $! > "$PID_FILE"
    notify-send "Screen Recorder" "Gravando... Execute novamente para parar."
fi
