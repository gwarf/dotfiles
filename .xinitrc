#!/bin/sh

LANG=fr_FR.UTF-8; export LANG
LC_ALL=fr_FR.UTF-8; export LC_ALL
MM_CHARSET=fr_FR.UTF-8; export MM_CHARSET

userxresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

[ -f $userxresources ] && xrdb -load $userxresources

[ -f $usermodmap ] && xmodmap $usermodmap
#xmodmap -e "remove Lock = Caps_Lock"
#xmodmap -e "keysym Caps_Lock = Control_L"
#xmodmap -e "add Control = Control_L"

[ -f ~/.xprofile ] && source ~/.xprofile

# Keybord layout setting
setxkbmap us -option 'compose:ralt'

# Ctrl+Alt+Backspace kills X
setxkbmap -option 'terminate:ctrl_alt_bksp'

#xhost +localhost
#xhost +local:root > /dev/null

# DPMS monitor setting (standby -> suspend -> off) (seconds)
xset dpms 300 600 900
# Disable beeps
xset -b
xset b off
# Turn on autorepeat
xset r on
# Mouse accelleration
xset m 3/1 3

export OOO_FORCE_DESKTOP=gnome

#export __GL_FSAA_MODE=1
#export __GL_LOG_MAX_ANISO=2
#export __GL_SYNC_TO_VBLANK=1

# for Gentoo
export XDG_MENU_PREFIX="gnome-"

# apps
#stalonetray &
# maison
#trayer --distance 28 --edge bottom --align right --margin 0 --widthtype request --height 30 --transparent true --alpha 100 --tint 1 &
# boulot
#trayer --edge bottom --distance 28 --align right --margin 2 --padding 10 --widthtype request --height 30 --transparent true --alpha 100 --tint 1 &
#sleep 1
#tomboy &
#alunn &
#pulseaudio -nF ~/.pulse/default.pa &
#workrave &
#nvidia-settings --load-config-only &
#~/bin/awesomestart.sh &
#/usr/libexec/gnome-settings-daemon &
#gnome-volume-manager &

#x11vnc -ncache 10 -many -q -bg -rfbauth .vnc/passwd

# start WM and keep pid so we can wait for it to exit

#eval $(gnome-keyring-daemon --start)
#export GNOME_KEYRING_SOCKET
#export GNOME_KEYRING_PID
# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus
#if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
#    eval $(dbus-launch --sh-syntax --exit-with-session)
#fi

# Start GNOME Keyring
eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

# Start urxvt demon
urxvtd -q -f -o & urxvtdpid=$!

# Keychain
#eval $(keychain --eval id_rsa)

#xrandr --output DVI-0 --mode  1680x1050_60 --pos 0x0 --output VGA-0 --mode 1280x1024_75 --pos 1680x0

# Awesome
#exec awesome & wmpid=$!
#exec ck-launch-session awesome & wmpid=$!

# bspwm
sxhkd &
[ -f ~/bin/autostart.sh ] && ~/bin/autostart.sh
#export CONKY_WIDTH=$(grep 'maximum_width' ~/.config/conky/conkyrc.$(hostname) | cut -d' ' -f2)
export CONKY_WIDTH="150"
# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --height 12 --transparent true --tint 0x000000 &
exec bspwm & wmpid=$!

# xmonad
#exec xmonad & wmpid=$!

wait $wmpid     # wait for the window manager to exit.

kill -15 `pidof workrave`
kill -15 `pidof offlineimap`
kill -15 `pidof gnome-session`
kill -15 `pidof gnome-keyring-daemon`
kill -15 `pidof pulseaudio`
kill -15 $urxvtdpid
