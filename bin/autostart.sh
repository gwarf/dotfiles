#!/bin/sh

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
xset b off
# Turn on autorepeat
xset r on
# Mouse acceleration
xset m 3/1 3
## Set LCD brightness
xbacklight -set 90
## Keyboard layout setting
setxkbmap us -option 'compose:ralt'
# Ctrl+Alt+Backspace kills X
setxkbmap -option 'terminate:ctrl_alt_bksp'
## Load Xmodmap conf
xmodmap ~/.Xmodmap
## Load Xresources
xrdb -load ~/.Xresources
# Make additional fonts available
xset +fp /usr/share/fonts/local
xset fp rehash

## OSD
run_once dunst

# Wallpapers
run_once nitrogen "--restore"

pkill offlineimap || sleep 3 && offlineimap &
#&& offlineimap-notify &> /tmp/offlineimap-log

# Pulse audio
pkill pulseaudio; sleep 3 && pulseaudio --start -D
pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo '60%' &
run_once pasystray
#exec --no-startup-id volti # starting volume control
#exec --no-startup-id pa-applet

# MPD
run_once mpd
run_once mpdscribble

# NetworkManager
run_once nm-applet

# Clipboard manager
# anamnesis, clipman, copyq, gpaste could be alternatives
run_once clipit

# Misc
run_once revelation \
  ~/repos/perso/gwarf/private/revelation/keyring-perso \
  "/usr/bin/python.*/bin/revelation.*/keyring-perso"
run_once revelation \
  ~/repos/perso/gwarf/private/revelation/keyring-maatg \
  "/usr/bin/python.*/bin/revelation.*/keyring-maatg"
run_once urxvtc
run_once pidgin
#run_once fink
#run_once firefox
run_once chromium
#run_once deluge
run_once kalu
run_once trayer
run_once redshift
run_once redshift-gtk
run_once rofi "-key mod1+tab -terminal urxvtc"
run_once JDownloader
run_once syncthing-gtk
#exec --no-startup-id udiskie
