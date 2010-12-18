# ~/.zshenv

export VISUAL="vim"
export EDITOR="vim"
LESS='-imJMWR'
PAGER="less $LESS"
MANPAGER=$PAGER
BROWSER='chromium-browser'
OS="$(uname)"
if [ "$OS" != "SunOS" ]; then
  export PAGER="most"
  export MANPAGER="most"
  # lesspipe
  export LESSOPEN="|lesspipe.sh %s"
  PATH="/usr/local/bin:/usr/local/sbin:/bin:/usr/bin:/usr/sbin:/usr/bin/X11:/usr/X11R6/bin:/usr/games:/sbin:/opt/texlive/bin:/opt/mozilla/bin:/opt/e17/bin:/opt/openoffice/program:/usr/local/openoffice.org-3.0.0/openoffice.org3/program:/opt/gnome/bin:$HOME/bin:$HOME/webtest/bin:/usr/lib/openoffice/program:$HOME/repos/git-achievements/:$PATH"
  CDPATH=$CDPATH::$HOME:/usr/local
else
  PATH=/opt/csw/bin:/usr/sbin:/sbin:/usr/bin:/usr/ruby/1.8/bin:/usr/dt/bin:/usr/openwin/bin:/usr/ccs/bin:/usr/gnu/bin:/usr/bin:/usr/X11/bin/usr/eclipse:/opt/sfw/bin:$PATH
  export TERM="xtermc"
fi
export PATH
export SDL_AUDIODRIVER="pulse"

# Set grep to ignore SCM directories
if ! $(grep --exclude-dir 2> /dev/null); then
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

#export PATH=/opt/sunjava/jre1.6.0_13/bin:$PATH
#export JAVA_HOME="/opt/sunjava/jre1.6.0_13"
export AXIS2_HOME="$HOME/dev/axis2-1.4.1/"
export PATH="/usr/share/java/apache-ant/bin:$PATH"
export JDK_MAJOR_VERSION=1.6
#export CATALINA_HOME=~/dev/liferay/liferay-portal-5.2.3/tomcat-6.0.18
export TOMCAT_MAJOR_VERSION=6.0

# For dcmtk
export DCMDICTPATH=/usr/lib/dicom.dic

export JSAGA_HOME="$HOME/dev/jsaga-0.9.8/"
export PATH=$JSAGA_HOME/bin:$PATH

# for eclim
#export ECLIM_ECLIPSE_HOME=/usr/share/eclipse

# Fix the gnome-terminal clear screen issue
#export TERM="xterm-noclear"

# ri doc formating
export RI="--format bs --width 70"
export CVS_RSH="ssh"

# mercurial
export HGEDITOR=~/bin/hgeditor

umask 022

[ -f ~/.alias ] && source ~/.alias
