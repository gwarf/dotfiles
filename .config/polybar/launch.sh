#!/bin/sh

# More info : https://github.com/jaagr/polybar/wiki

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

for m in $(polybar --list-monitors | cut -d":" -f1); do
  #MONITOR=$m polybar --reload mainbar-herbstluftwm -c ~/.config/polybar/config &
  MONITOR=$m polybar --reload primary -c ~/.config/polybar/config2 &
done
