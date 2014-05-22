#!/bin/sh

## Disable beeps
xset -b &

## DPMS monitor setting (standby -> suspend -> off) (seconds)
xset dpms 300 600 900 &

## Set LCD brightness
xbacklight -set 90 &

## Keybord layout setting
setxkbmap us -option 'compose:ralt' &

## Load Xmodmap conf
#xmodmap -e "remove Lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Control_L"
#xmodmap -e "add Control = Control_L"
xmodmap ~/.Xmodmap &

## Load Xresources
xmxrdb -load ~/.Xresources &

## OSD
dunst &

# Wallpapers
nitrogen --restore &

pkill offlineimap || sleep 3 && offlineimap &

# Pulse audio
pkill pulseaudio; sleep 3 && pulseaudio --start &
pactl set-sink-volume 0 '60%' &
pasystray &

# MPD
mpd &

# NetworkManager
nm-applet &

# Clipboard manager
clipit &

# Misc
revelation ~/repos/perso/gwarf/private/revelation/keyring-perso &
revelation ~/repos/perso/gwarf/private/revelation/keyring-maatg &
terminator &
pidgin &
firefox &
deluge &
jdownloader &
