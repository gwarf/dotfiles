#!/bin/sh

# More info : https://github.com/jaagr/polybar/wiki

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u "$(id -u)" -x polybar > /dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR=$m polybar --reload main -c ~/.config/polybar/config.ini &
  #MONITOR=$m polybar --reload primary -c ~/.config/polybar/config2 &
  #MONITOR=$m polybar --reload example -c ~/.config/polybar/config &
done
