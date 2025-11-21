#!/bin/bash

# ╔═══════════════════════════════════════════════════════════════════════════╗
# ║                        🍅 POMODORO TIMER 🍅                               ║
# ║                      Stellar Dots Productivity Tool                        ║
# ╚═══════════════════════════════════════════════════════════════════════════╝

WORK_TIME=1500  # 25 minutes
BREAK_TIME=300  # 5 minutes
LONG_BREAK=900  # 15 minutes

STATE_FILE="/tmp/pomodoro-state"
PID_FILE="/tmp/pomodoro-pid"

# Check if timer is running
is_running() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        if ps -p "$pid" > /dev/null 2>&1; then
            return 0
        fi
    fi
    return 1
}

# Start work session
start_work() {
    echo "work" > "$STATE_FILE"
    echo $$ > "$PID_FILE"
    
    notify-send "Pomodoro" "Sessão de trabalho iniciada (25min)" -i clock
    
    sleep $WORK_TIME
    
    notify-send "Pomodoro" "Hora do intervalo! (5min)" -u critical -i emblem-important
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null
    
    start_break
}

# Start break
start_break() {
    echo "break" > "$STATE_FILE"
    
    sleep $BREAK_TIME
    
    notify-send "Pomodoro" "Intervalo terminado! Pronto para trabalhar?" -u critical -i emblem-important
    paplay /usr/share/sounds/freedesktop/stereo/complete.oga 2>/dev/null
    
    rm -f "$STATE_FILE" "$PID_FILE"
}

# Stop timer
stop_timer() {
    if [ -f "$PID_FILE" ]; then
        pid=$(cat "$PID_FILE")
        kill "$pid" 2>/dev/null
        rm -f "$STATE_FILE" "$PID_FILE"
        notify-send "Pomodoro" "Timer parado" -i process-stop
    fi
}

# Get status
get_status() {
    if is_running; then
        state=$(cat "$STATE_FILE" 2>/dev/null || echo "unknown")
        echo "Pomodoro: $state"
    else
        echo "Pomodoro: parado"
    fi
}

# Menu
if is_running; then
    menu="⏸️ Parar Timer
📊 Status"
else
    menu="▶️ Iniciar Trabalho (25min)
☕ Iniciar Intervalo (5min)"
fi

chosen=$(echo -e "$menu" | rofi -dmenu -p "Pomodoro Timer" -theme ~/.config/rofi/power-menu.rasi)

case "$chosen" in
    "▶️ Iniciar Trabalho"*)
        start_work &
        ;;
    "☕ Iniciar Intervalo"*)
        start_break &
        ;;
    "⏸️ Parar Timer")
        stop_timer
        ;;
    "📊 Status")
        status=$(get_status)
        notify-send "Pomodoro" "$status" -i clock
        ;;
esac
