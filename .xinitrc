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

# Set default black background
xsetroot -solid black
xsetroot -cursor_name left_ptr

# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &

# Give opacity to specific windows. See ~/.devilspie/opacity.ds
#devilspie -a &

# Start a D-Bus session
source /etc/X11/xinit/xinitrc.d/30-dbus

# starting compositor
compton -b
# slow virtual desktop switching
# compton --respect-prop-shadow -bc -t -8 -l -9 -r 6 -o 0.7 &
# compton -cCGfF -o 0.38 -O 200 -I 200 -t 0.02 -l 0.02 -r 3.2 -D2 -m 0.88 -i 0 &
# compton -cCGfzb -o 0.8 -O 200 -I 200 -t -9 -l -9 -r 6 -D 2 -m 0.98 -e
# 1 -i 1 --respect-prop-shadow --shadow-ignore-shaped

# Start GNOME Keyring
#eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GNOME_KEYRING_SOCKET
#export GPG_AGENT_INFO SSH_AUTH_SOCK

# Keychain
#eval $(keychain --eval id_rsa)

# Start urxvt daemon
#urxvtd -q -f -o & urxvtdpid=$!
urxvtd -f -o

trayer --edge top --align right \
 --SetDockType true --SetPartialStrut true \
 --expand true --width 15 --height 12 \
 --transparent true --tint 0x000000 --alpha 100 &

# Autstart applications
[ -f ~/bin/autostart.sh ] && ~/bin/autostart.sh

# Start WM and keep pid so we can wait for it to exit

# Awesome
#~/bin/awesomestart.sh &
#exec awesome & wmpid=$!
#exec ck-launch-session awesome & wmpid=$!

# i3
exec i3 & wmpid=$!

# bspwm
#sxhkd &
##export CONKY_WIDTH=$(grep 'maximum_width' ~/.config/conky/conkyrc.$(hostname) | cut -d' ' -f2)
#export CONKY_WIDTH="150"
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
