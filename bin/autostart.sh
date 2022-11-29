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
    pgrep -u "$USER" -x "$process_name" || ( "$program" & ) else
    pgrep -f -u "$USER" -x "$process_name" || ( "$program" "$program_arguments" & )
  fi
}

## OSD
run_once dunst

# Clipboard manager
# anamnesis, clipman, copyq, gpaste could be alternatives
run_once clipit

# Misc
run_once kitty
run_once firefox
run_once run_keybase
run_once nextcloud --background
# run_once redshift
# run_once redshift-gtk

# Disable offlineimap while testing a user systemd service + timer
# pkill offlineimap || sleep 3 && offlineimap &
#&& offlineimap-notify &> /tmp/offlineimap-log

# Pulse audio
# pkill pulseaudio; sleep 3 && pulseaudio --start -D
# pactl set-sink-volume alsa_output.pci-0000_00_1b.0.analog-stereo '60%' &
# run_once pasystray
# exec --no-startup-id volti # starting volume control
# exec --no-startup-id pa-applet

# MPD
# run_once mpd
# run_once mpdscribble

# NetworkManager
# run_once nm-applet

# Disabled
# run_once workrave
# run_once chromium
# run_once deluge
# stalonetray &
# tomboy &
# alunn &
# workrave &
# nvidia-settings --load-config-only &
# run_once syncthing-gtk
# run_once flow
# run_once kontaminuti
# exec --no-startup-id udiskie
# /usr/libexec/gnome-settings-daemon &
# gnome-volume-manager &
# x11vnc -ncache 10 -many -q -bg -rfbauth .vnc/passwd
# run conky -c $HOME/.conkyrc &
# albert &
# run mpd &
# run variety &
# run nm-applet &
# pamac-tray &
# xinput set-prop 13 302 1 &
# run redshift-gtk
# run syncthing-gtk -m &
# xfce4-power-manager &
# run dunst &
# numlockx on &
# run blueberry-tray &
# xfsettingsd &
# nitrogen --restore &
# caffeine &
# vivaldi-stable &
# firefox &
# thunar &
# dropbox &
# run insync start &
# discord &
# spotify &
# atom &
# keybindings are in config of sxhkd - interchangeable with other TWM
# run sxhkd -c $HOME/.config/herbstluftwm/sxhkd/sxhkdrc &
# wal -i ~/.config/herbstluftwm/fantasy-landscape2.jpg
# wal -nRa 90 &

# Set wallpaper
# run_once nitrogen "--restore"
feh --no-fehbg --bg-fill ~/.config/herbstluftwm/fantasy-landscape2.jpg &

# Compositor
# picom --shadow-opactiy 0.25 &
