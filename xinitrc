# Initialize X conf and launch window manager

# Unclutter - hides the mouse cursor after 5 seconds of idle
unclutter -root -jitter 10 &

# Disable beeps
xset -b

# DPMS monitor setting (standby -> suspend -> off) (seconds)
xset dpms 600 1200 3600

# Set default black background
xsetroot -solid '#101010'
xsetroot -cursor_name left_ptr

# https://wiki.archlinux.org/index.php/GNOME/Keyring
# XXX useful?
# dbus-update-activation-environment --systemd DISPLAY

# https://askubuntu.com/questions/725115/how-to-start-gnome-keyring-daemon-outside-of-unity
# Launch gnome-keyring-daemon for secrets, ssh keys and gpg
# if [ -n "$PS1" ] && [ -z "$SSH_CONNECTION" ]; then
# eval $(/usr/bin/gnome-keyring-daemon --start --components=gpg,secrets,ssh)
# export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
# fi
eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
export SSH_AUTH_SOCK

# Verbose i3
# exec i3 -V > ~/tmp/i3log 2>&1
exec i3 > ~/tmp/i3log 2>&1
