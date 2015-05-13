# ~/.zshenv

LC_ALL='fr_FR.UTF-8'
LANG='fr_FR.UTF-8'
export LC_ALL LANG

export VISUAL="vim"
export EDITOR="vim"
export TERMINAL='terminator'

# Set the default Less options.
# Mouse-wheel scrolling has been disabled by -X (disable screen clearing).
# Remove -X and -F (exit if the content fits on one screen) to enable it.
#export LESS='-F -g -i -M -R -S -w -X -z-4'
LESS='-imJMWR'

# Set the Less input preprocessor.
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

PAGER="less $LESS"
MANPAGER=$PAGER
BROWSER='chromium-browser'
OS="$(uname)"
if [ "$OS" != "SunOS" ]; then
  export PAGER="most"
  # lesspipe
  export LESSOPEN="|lesspipe.sh %s"
  PATH="/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/usr/sbin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/sbin:/opt/texlive/bin:/opt/mozilla/bin:/opt/e17/bin:/opt/openoffice/program:/usr/local/openoffice.org-3.0.0/openoffice.org3/program:/opt/gnome/bin:$HOME/bin:$HOME/webtest/bin:/usr/lib/openoffice/program:$HOME/repos/git-achievements/:/usr/lib64/libreoffice/program:/usr/libexec:$PATH"
  CDPATH="$CDPATH::$HOME:/usr/local"
else
  PATH="/opt/csw/bin:/usr/sbin:/sbin:/usr/bin:/usr/ruby/1.8/bin:/usr/dt/bin:/usr/openwin/bin:/usr/ccs/bin:/usr/gnu/bin:/usr/bin:/usr/X11/bin/usr/eclipse:/opt/sfw/bin:$PATH"
  export TERM="xtermc"
fi
export SDL_AUDIODRIVER="pulse"

#
# Temporary Files
#

if [[ ! -d "$TMPDIR" ]]; then
  export TMPDIR="/tmp/$USER"
  mkdir -p -m 700 "$TMPDIR"
fi

TMPPREFIX="${TMPDIR%/}/zsh"
if [[ ! -d "$TMPPREFIX" ]]; then
  mkdir -p "$TMPPREFIX"
fi

# Gem on archlinux
#if [ -d "$HOME/.gem/ruby/2.0.0/bin" ]; then
#  PATH="/home/baptiste/.gem/ruby/2.0.0/bin:$PATH"
#  export GEM_HOME="$HOME/.gem/ruby/2.0.0"
#fi
#if [ -d "$HOME/.gem/ruby/2.1.0/bin" ]; then
#  PATH="/home/baptiste/.gem/ruby/2.1.0/bin:$PATH"
#  export GEM_HOME="$HOME/.gem/ruby/2.1.0"
#fi

# Haskell cabal conf
if [ -d "$HOME/.cabal/bin" ]; then
  PATH="$HOME/.cabal/bin:$PATH"
fi

if [ -x '~/.gem/ruby/2.0.0/bin/chit' ]; then
  chit () { '~/.gem/ruby/2.0.0/bin/chit' "$@" | "$PAGER" }
fi

# For java apps under awesome
# http://awesome.naquadah.org/wiki/Problems_with_Java
#export AWT_TOOLKIT="MToolkit"
# new method:
#export _JAVA_AWT_WM_NONREPARENTING=1

# For dcmtk
#export DCMDICTPATH=/usr/lib/dicom.dic

# for eclim
#export ECLIM_ECLIPSE_HOME=/usr/share/eclipse

# Fix the gnome-terminal clear screen issue
#export TERM="xterm-noclear"

# Use a 256color term
export TERM="xterm-256color"
[ -n "$TMUX" ] && export TERM="screen-256color"

# ri doc formating
export RI="--format bs --width 70"
export CVS_RSH="ssh"

# mpd host
if [ $(hostname) = 'bougebox' -o $(hostname) = 'monster.maatg.fr' ]; then
  export MPD_HOST="toglut@localhost"
else
  export MPD_HOST="toglut@htpc"
fi

# mercurial
export HGEDITOR=~/bin/hgeditor

umask 0027

# Proxy HTTP / FTP without password
#export http_proxy="http://proxy.exemple.org:8080"
#export ftp_proxy="ftp://proxy.exemple.org:8080"

# Proxy HTTP / FTP with password
#export http_proxy="http://login:password@proxy.exemple.org:8080"
#export ftp_proxy="ftp://login:password@proxy.exemple.org:8080"

# Disable proxy for example.org
#export no_proxy="exemple.org"

#if [ `hostname` = 'bougebox' ]; then
#  source /opt/UItar/etc/profile.d/grid-env.sh
#fi

# Source grid environment
[ -f /opt/emi/etc/profile.d/grid-env.sh ] && . /opt/emi/etc/profile.d/grid-env.sh

#export WINEARCH=win32

[ -f ~/.alias ] && source ~/.alias

export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=256m"

# Use gnome keyring for ssh auth
#export SSH_AUTH_SOCK="$GNOME_KEYRING_CONTROL/ssh"
#if [ -n "$DESKTOP_SESSION" ];then
#  # No point to start gnome-keyring-daemon if ssh-agent is not up
#  if [ -n "$GNOME_KEYRING_PID" ]; then
#    eval $(gnome-keyring-daemon --start --components=gpg,pkcs11,secrets,ssh)
#    export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GNOME_KEYRING_SOCKET
#    export GPG_AGENT_INFO SSH_AUTH_SOCK
#  fi
#fi

# Keychain
#eval $(keychain --eval id_rsa)

# Use envoy for ssh/gpg agent
# use envoy -a to add identities to agent
# https://github.com/vodik/envoy
if command -v "envoy" >/dev/null 2>&1; then
  envoy -t ssh-agent
  source <(envoy -p)
fi

# Load RVM into a shell session *as a function*
[ -s "$HOME/.rvm/scripts/rvm" ] && source "$HOME/.rvm/scripts/rvm"
if [ -d "$HOME/.rvm/bin" ]; then
  # Add RVM to PATH for scripting
  PATH="$PATH:$HOME/.rvm/bin"
fi

# Load rbenv
if command -v "rbenv" >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

#PATH="~/.bundler_binstubs:$PATH"

if [ -d "$HOME/.mc/lib/mc-solarized-skin" ]; then
  export MC_SKIN=$HOME/.mc/lib/mc-solarized-skin/solarized.ini
else
  git clone https://github.com/iwfmp/mc-solarized-skin.git $HOME/.mc/lib/mc-solarized-skin
fi

#
# Paths
#

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path

# Set the list of directories that Zsh searches for programs.
path=(
  ~/bin
  /usr/local/{bin,sbin}
  $path
)

export PATH

# Configure bspwm's panel
PANEL_FIFO=/tmp/panel-fifo
PANEL_HEIGHT=24
PANEL_FONT_FAMILY="-*-terminus-medium-r-normal-*-12-*-*-*-c-*-*-1"
export PANEL_FIFO PANEL_HEIGHT PANEL_FONT_FAMILY

export OOO_FORCE_DESKTOP=gnome
export XDG_MENU_PREFIX="gnome-"

# vim:set ft=zsh ts=2 sw=2 et:
