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

## OSD
run_once dunst

# Wallpapers
#run_once nitrogen "--restore"

# Disable offlineimap while testing a user systemd service + timer
# pkill offlineimap || sleep 3 && offlineimap &
#&& offlineimap-notify &> /tmp/offlineimap-log

# Pulse audio
# pkill pulseaudio; sleep 3 && pulseaudio --start -D
# pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo '60%' &
# run_once pasystray
#exec --no-startup-id volti # starting volume control
#exec --no-startup-id pa-applet

# MPD
# run_once mpd
# run_once mpdscribble

# NetworkManager
# run_once nm-applet

# Clipboard manager
# anamnesis, clipman, copyq, gpaste could be alternatives
# run_once clipit

# Start urxvt daemon
#urxvtd -q -f -o & urxvtdpid=$!
#urxvtd -f -o

# Misc
run_once kitty
run_once firefox
run_once redshift
run_once redshift-gtk
run_once rofi "-key mod1+tab -terminal kitty"

# Disabled
# run_once revelation \
#   ~/repos/perso/gwarf/private/revelation/keyring-perso \
#   "/usr/bin/python.*/bin/revelation.*/keyring-perso"
# run_once revelation \
#   ~/repos/perso/gwarf/private/revelation/keyring-maatg \
#   "/usr/bin/python.*/bin/revelation.*/keyring-maatg"
#run_once JDownloader
#run_once workrave
#run_once chromium
#run_once deluge
#stalonetray &
#tomboy &
#alunn &
#workrave &
#nvidia-settings --load-config-only &
#run_once syncthing-gtk
#run_once owncloud
#run_once flow
#un_once kontaminuti
#exec --no-startup-id udiskie
#/usr/libexec/gnome-settings-daemon &
#gnome-volume-manager &
#x11vnc -ncache 10 -many -q -bg -rfbauth .vnc/passwd

