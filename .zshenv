# ~/.zshenv

LC_ALL='fr_FR.UTF-8'
LANG='fr_FR.UTF-8'
export LC_ALL LANG

export VISUAL="vim"
export EDITOR="vim"
export TERMINAL='terminator'
LESS='-imJMWR'
PAGER="less $LESS"
MANPAGER=$PAGER
BROWSER='chromium-browser'
OS="$(uname)"
if [ "$OS" != "SunOS" ]; then
  export PAGER="most"
  export MANPAGER="most -s"
  # lesspipe
  export LESSOPEN="|lesspipe.sh %s"
  PATH="/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/usr/sbin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/sbin:/opt/texlive/bin:/opt/mozilla/bin:/opt/e17/bin:/opt/openoffice/program:/usr/local/openoffice.org-3.0.0/openoffice.org3/program:/opt/gnome/bin:$HOME/bin:$HOME/webtest/bin:/usr/lib/openoffice/program:$HOME/repos/git-achievements/:/usr/lib64/libreoffice/program:/usr/libexec:$PATH"
  CDPATH="$CDPATH::$HOME:/usr/local"
else
  PATH="/opt/csw/bin:/usr/sbin:/sbin:/usr/bin:/usr/ruby/1.8/bin:/usr/dt/bin:/usr/openwin/bin:/usr/ccs/bin:/usr/gnu/bin:/usr/bin:/usr/X11/bin/usr/eclipse:/opt/sfw/bin:$PATH"
  export TERM="xtermc"
fi
export SDL_AUDIODRIVER="pulse"

# Gem on archlinux
#if [ -d "$HOME/.gem/ruby/2.0.0/bin" ]; then
#  PATH="/home/baptiste/.gem/ruby/2.0.0/bin:$PATH"
#  export GEM_HOME="$HOME/.gem/ruby/2.0.0"
#fi
#if [ -d "$HOME/.gem/ruby/2.1.0/bin" ]; then
#  PATH="/home/baptiste/.gem/ruby/2.1.0/bin:$PATH"
#  export GEM_HOME="$HOME/.gem/ruby/2.1.0"
#fi
#
if [ -d "$HOME/.cabal/bin" ]; then
  PATH="$HOME/.cabal/bin:$PATH"
fi

if [ -x '~/.gem/ruby/2.0.0/bin/chit' ]; then
  chit () { '~/.gem/ruby/2.0.0/bin/chit' "$@" | "$PAGER" }
fi

# Set grep to ignore SCM directories
grep --exclude-dir 2> /dev/null
if [ $? -eq 0 ]; then
    GREP_OPTIONS="--color --exclude-dir=.svn --exclude=\*.pyc --exclude-dir=.hg --exclude-dir=.bzr --exclude-dir=.git"
else
    GREP_OPTIONS="--color --exclude=\*.svn\* --exclude=\*.pyc --exclude=\*.hg\* --exclude=\*.bzr\* --exclude=\*.git\*"
fi
export GREP_OPTIONS
# For java apps under awesome
# http://awesome.naquadah.org/wiki/Problems_with_Java
#export AWT_TOOLKIT="MToolkit"
# new method:
#export _JAVA_AWT_WM_NONREPARENTING=1

# For browser in eclipse
#export MOZILLA_FIVE_HOME="/usr/lib/xulrunner"

#PATH=/opt/sunjava/jre1.6.0_13/bin:$PATH
#export JAVA_HOME="/opt/sunjava/jre1.6.0_13"
#export AXIS2_HOME="/home/baptiste/dev/axis2-1.4.1/"
#PATH="/usr/share/java/apache-ant/bin:$PATH"
#export JDK_MAJOR_VERSION=1.6
#export CATALINA_HOME=~/dev/liferay/liferay-portal-5.2.3/tomcat-6.0.18
#export TOMCAT_MAJOR_VERSION=6.0

# For dcmtk
#export DCMDICTPATH=/usr/lib/dicom.dic

#export JSAGA_HOME="/home/baptiste/dev/jsaga-0.9.8/"
#PATH="$JSAGA_HOME/bin:$PATH"

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

umask 022

# Proxy HTTP / FTP sans mot de passe
#export http_proxy="http://proxy.exemple.org:8080"
#export ftp_proxy="ftp://proxy.exemple.org:8080"

# Proxy HTTP / FTP avec mot de passe
#export http_proxy="http://login:password@proxy.exemple.org:8080"
#export ftp_proxy="ftp://login:password@proxy.exemple.org:8080"

# Ne pas passer par le proxy pour les domaines locaux
#export no_proxy="exemple.org"
#if [ `hostname` = 'bougebox' ]; then
#  source /opt/UItar/etc/profile.d/grid-env.sh
#fi

[ -f /opt/emi/etc/profile.d/grid-env.sh ] && . /opt/emi/etc/profile.d/grid-env.sh

#export WINEARCH=win32


[ -f ~/.alias ] && source ~/.alias
export ANT_OPTS="-Xmx1024m -XX:MaxPermSize=256m"

export PATH

# Use gnome keyring for ssh auth
#export SSH_AUTH_SOCK="$GNOME_KEYRING_CONTROL/ssh"
#if [ -n "$DESKTOP_SESSION" ];then
  #if [ -n "$GNOME_KEYRING_PID" ]; then
    eval $(gnome-keyring-daemon --start --components=ssh,gpg)
    #export GNOME_KEYRING_CONTROL GNOME_KEYRING_PID GPG_AGENT_INFO SSH_AUTH_SOCK
    export GPG_AGENT_INFO SSH_AUTH_SOCK
  #fi
#fi
# vim:set ts=2 sw=2 expandtab:
