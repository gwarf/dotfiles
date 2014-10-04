#!/bin/sh

set -x

# Run a program only once
#
# run_once $program, $program_arguments, $process_name
run_once() {
  program="$1"
  program_arguments="$2"
  process_name="$3"

  [ -z "$process_name" ] && process_name="$program"

  if [ -z "$program_arguments" ]; then
    pgrep -f -u $USER -x "$process_name" || ( "$program" & )
  else
    pgrep -f -u $USER -x "$process_name" || ( "$program" "$program_arguments" & )
  fi
}

## Disable beeps
xset -b

## DPMS monitor setting (standby -> suspend -> off) (seconds)
xset dpms 300 600 900

## Set LCD brightness
xbacklight -set 90

## Keybord layout setting
setxkbmap us -option 'compose:ralt'

## Load Xmodmap conf
#xmodmap -e "remove Lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Control_L"
#xmodmap -e "add Control = Control_L"
xmodmap ~/.Xmodmap

## Load Xresources
xrdb -load ~/.Xresources

## OSD
run_once dunst

# Wallpapers
run_once nitrogen "--restore"

pkill offlineimap || sleep 3 && offlineimap &

# Pulse audio
pkill pulseaudio; sleep 3 && pulseaudio --start -D
pactl set-sink-volume 0 '60%' &
run_once pasystray

# MPD
run_once mpd
run_once mpdscribble

# NetworkManager
run_once nm-applet

# Clipboard manager
run_once clipit

# Misc
run_once revelation \
  ~/repos/perso/gwarf/private/revelation/keyring-perso \
  "/usr/bin/python.*/bin/revelation.*/keyring-perso"
run_once revelation \
  ~/repos/perso/gwarf/private/revelation/keyring-maatg \
  "/usr/bin/python.*/bin/revelation.*/keyring-maatg"
run_once terminator
run_once pidgin
run_once firefox
#run_once deluge
run_once JDownloader
run_once syncthing-gtk
