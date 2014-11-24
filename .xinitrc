#!/bin/sh

LANG=fr_FR.UTF-8; export LANG
LC_ALL=fr_FR.UTF-8; export LC_ALL
MM_CHARSET=fr_FR.UTF-8; export MM_CHARSET

userxresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

[ -f $userxresources ] && xrdb -load $userxresources

[ -f $usermodmap ] && xmodmap $usermodmap

[ -f ~/.xprofile ] && source ~/.xprofile

#xhost +localhost
#xhost +local:root > /dev/null

# Disable beeps
xset -b

# DPMS monitor setting (standby -> suspend -> off) (seconds)
xset dpms 300 600 900
xset b off

# Turn on autorepeat
xset r on

# Mouse acceleration
xset m 3/1 3

## Set LCD brightness
xbacklight -set 90

# Keyboard layout setting
setxkbmap us -option 'compose:ralt'
# Ctrl+Alt+Backspace kills X
setxkbmap -option 'terminate:ctrl_alt_bksp'

# Make additional fonts available
xset +fp /usr/share/fonts/local
xset fp rehash

# Give opacity to specific windows. See ~/.devilspie/opacity.ds
#devilspie -a &

# Redshift - changed screen colour temp
#redshift-gtk -l 55.978301:-3.228586 -t 6000:4500 &

# slow virtual desktop switching
# compton --respect-prop-shadow -bc -t -8 -l -9 -r 6 -o 0.7 &
# compton -cCGfF -o 0.38 -O 200 -I 200 -t 0.02 -l 0.02 -r 3.2 -D2 -m
# 0.88 -i 0 &
# compton -cCGfzb -o 0.8 -O 200 -I 200 -t -9 -l -9 -r 6 -D 2 -m 0.98 -e
# 1 -i 1 --respect-prop-shadow --shadow-ignore-shaped

export OOO_FORCE_DESKTOP=gnome

#export __GL_FSAA_MODE=1
#export __GL_LOG_MAX_ANISO=2
#export __GL_SYNC_TO_VBLANK=1

# for Gentoo
export XDG_MENU_PREFIX="gnome-"

# Set default black background
xsetroot -solid black
xsetroot -cursor_name left_ptr

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
#eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
# You probably need to do this too:
#export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK

# Start urxvt daemon
#urxvtd -q -f -o & urxvtdpid=$!
urxvtd -f -o

# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &

# Autstart applications
[ -f ~/bin/autostart.sh ] && ~/bin/autostart.sh

# Keychain
#eval $(keychain --eval id_rsa)

#xrandr --output DVI-0 --mode  1680x1050_60 --pos 0x0 --output VGA-0 --mode 1280x1024_75 --pos 1680x0

# starting compositor
compton -b

# Awesome
#exec awesome & wmpid=$!
#exec ck-launch-session awesome & wmpid=$!

# i3
exec i3 & wmpid=$!

# bspwm
#sxhkd &
##export CONKY_WIDTH=$(grep 'maximum_width' ~/.config/conky/conkyrc.$(hostname) | cut -d' ' -f2)
#export CONKY_WIDTH="150"
#trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --height 12 --transparent true --tint 0x000000 &
#exec bspwm & wmpid=$!

# hebsluftwm
# start herbstluftwm in locked mode (it will be unlocked at the end of
# your autostart)
#exec herbstluftwm --locked

# xmonad
#exec xmonad & wmpid=$!

wait $wmpid     # wait for the window manager to exit.

kill -15 `pidof workrave`
kill -15 `pidof offlineimap`
kill -15 `pidof gnome-session`
kill -15 `pidof gnome-keyring-daemon`
kill -15 `pidof pulseaudio`
kill -15 $urxvtdpid
