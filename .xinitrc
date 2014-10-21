#!/bin/sh

LANG=fr_FR.UTF-8; export LANG
LC_ALL=fr_FR.UTF-8; export LC_ALL
MM_CHARSET=fr_FR.UTF-8; export MM_CHARSET

#sysresources=/usr/X11R6/lib/X11/xinit/.Xresources
#sysmodmap=/usr/X11R6/lib/X11/xinit/.Xmodmap
userxresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap

# merge in defaults and keymaps
#if [ -f $sysresources ]; then
#    xrdb -merge $sysresources
#fi

#if [ -f $sysmodmap ]; then
#    xmodmap $sysmodmap
#fi

[ -f $userxresources ] && xrdb -load $userxresources

[ -f ~/.xprofile ] && source ~/.xprofile

# load xkeymap
setxkbmap us -option 'compose:ralt'

# Ctrl+Alt+Backspace kills X
setxkbmap -option 'terminate:ctrl_alt_bksp'

# gestion des boutons de la souris
#/usr/X11R6/bin/xmodmap -e "pointer = 1 2 3 6 7 4 5" &
#/usr/bin/imwheel -p -b "67" &

#xcompmgr -fF -I-.002 -O-.003 -D1 &
#xcompmgr -c &
#xcompmgr &

# sudo killall -9 esd
#fbsetbg -f ~/.fluxbox/bg.png
#xsetroot -solid black
#xsetroot -bg black
#eval $(cat ~/.fehbg)

#xhost +localhost
#xhost +local:root > /dev/null

#xset -dpms s on
xset dpms
# Turn off bip
xset b off
# Turn on autorepeat
xset r on
# Mouse accelleration
xset m 3/1 3

# verrouillage du pavé numérique
#exec numlockx &

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
#deluge &
#workrave &
#nvidia-settings --load-config-only &
#urxvtd -q -f -o & urxvtdpid=$!
#~/bin/awesomestart.sh &
#xcompmgr -f &
#pidgin &
#/usr/libexec/gnome-settings-daemon &
#gnome-volume-manager &

# Conf for htpc
#x11vnc -ncache 10 -many -q -bg -rfbauth .vnc/passwd
#for i in 5 4 3 2 1 ; do
#  if [ -f mythfrontend.log.$i ]; then
#    mv -f mythfrontend.log.$i  mythfrontend.log.$(($i + 1))
#  fi
#done
#mv mythfrontend.log  mythfrontend.log.1
#mythfrontend > /home/baptiste/mythfrontend.log 2>&1

# start WM and keep pid so we can wait for it to exit
#exec /opt/e17/bin/enlightenment_start & wmpid=$!
#exec fvwm
#exec fvwm-crystal 2> ~/.fvwm-crystal/fvwm-crystal.log & wmpid=$!
#exec gnome-session & wmpid=$!
#exec ck-launch-session gnome-session & wmpid=$!
#exec xfce4-session & wmpid=$!
# ck-launch-session is advised for the dbus stuff to work fine.
#exec ck-launch-session awesome & wmpid=$!

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

# Keychain
#eval $(keychain --eval id_rsa)

# gnome + fluxbox
#exec ck-launch-session startfluxbox & wmpid=$!

# Awesome
#exec awesome & wmpid=$!
#exec ck-launch-session awesome & wmpid=$!

# Start urxvt demon
urxvtd -q -f -o &

# bspwm
sxhkd &
[ -f ~/bin/autostart.sh ] && ~/bin/autostart.sh
#export CONKY_WIDTH=$(grep 'maximum_width' ~/.config/conky/conkyrc.$(hostname) | cut -d' ' -f2)
export CONKY_WIDTH="150"
# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &
trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --width 15 --height 12 --transparent true --tint 0x000000
exec bspwm & wmpid=$!

# xmonad
#exec xmonad & wmpid=$!

# gnome + awesome
#exec ck-launch-session gnome-session & wmpid=$!

#if [ `hostname` = 'bougebox' ]; then
#  exec ck-launch-session dbus-launch openbox-session & wmpid=$!
#else
# exec ck-launch-session fvwm & wmpid=$!
#fi
#exec wmfs & wmpid=$!
#exec openbox
#exec pekwm
#exec ratpoison & wmpid=$!
#exec startfluxbox
#exec startkde & wmpid=$!
#exec startxfce4
#exec startxpde

# games
#exec quake3
#exec ut2004

#xrandr --output DVI-0 --mode  1680x1050_60 --pos 0x0 --output VGA-0 --mode 1280x1024_75 --pos 1680x0

wait $wmpid     # wait for the window manager to exit.

kill -15 `pidof workrave`
kill -15 `pidof offlineimap`
kill -15 `pidof gnome-session`
kill -15 `pidof gnome-keyring-daemon`
#kill -15 `pidof pulseaudio`
#kill -9 `pidof jackd` # kill jack daemon
#kill -15 $urxvtdpid

#if [ -f $HOME/.aMule/muleLock ]; then
#    rm -f $HOME/.aMule/muleLock
#fi
