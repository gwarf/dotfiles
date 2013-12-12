# ZSH configuration for interactive shells

# oh-my-zsh
#curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
# Source system profile
source /etc/profile

[ -f ~/.zshenv ] && source ~/.zshenv

export SHELL=`which zsh`

fpath=( ~/.zsh_functions $fpath )
[[ -d $HOME/.zsh_functions/VCS_Info ]] \
  && fpath[1]=( ${fpath[1]} $HOME/.zsh_functions/**/* )

autoload -U colors && colors
autoload -U promptinit
autoload -Uz vcs_info

# Is the connection over SSH ?
SSH=no
OS="$(uname)"
if [ "$OS" != "SunOS" ]; then
  if who am i | grep -q '([^:]*)$'; then
    SSH=yes
  fi
  user=$(who am i | cut -f 1 -d' ')
  if [ $(id -u) -eq 0 -a -z "$user" -a "$user" != 'root' ]; then
    SSH=yes
  fi
fi

# Do we have root privileges ?
ROOT=no
if [ $(id -u) -eq 0 ]; then
  ROOT=yes
fi

# Define constants for colors in prompt.
local reset white grey green red yellow
reset="%{${reset_color}%}"
white="%{$fg[white]%}"
brightwhite="%{$fg_bold[white]%}"
blue="%{$fg[blue]%}"
brightblue="%{$fg_bold[blue]%}"
grey="%{$fg[black]%}"
brightgrey="%{$fg_bold[black]%}"
green="%{$fg_bold[green]%}"
red="%{$fg[red]%}"
brightred="%{$fg_bold[red]%}"
yellow="%{$fg[yellow]%}"
brightyellow="%{$fg_bold[yellow]%}"
pink="%{[35m%}"

CSEP="%{[0m[33;1m%}"
CHOST="%{[37;1m%}"
CPROMPT="%{[1;32m%}"
case $ROOT in
  yes)
  CSTART="%{[31;1m%}"
  case $SSH in
    yes)
    CHOST="%{[41;37;1m%}"
    ;;
  esac
  ;;
  no)
  CSTART="%{[34;1m%}"
  case $SSH in
    yes)
    CHOST="%{[46;37;1m%}"
    ;;
  esac
  ;;
esac

case $TERM in
  screen|screen-w)
  alias titlecmd="screen_title"
  ;;
  xterm|rxvt)
  alias titlecmd="xterm_title"
  ;;
  *)
  alias titlecmd=":"
  ;;
esac

xterm_title() {
  builtin print -n -P -- "\e]0;$@\a"
}

screen_title() {
  builtin print -n -P -- "\ek$@\e\\"
  xterm_title "$@"
}

precmd () {
#  titlecmd "%m %4~"
  vcs_info
  setprompt
}

## autoset title based on location and process
preexec () {
#  titlecmd "%m %4~" ":" "\"$1\""
}

ssh() {
  titlecmd "$1";
  command ssh $*;
  titlecmd "$HOSTNAME";
}

# http://zsh.sourceforge.net/Doc/Release/User-Contributions.html#SEC273
zstyle ':vcs_info:*' enable git svn cvs hg
zstyle ':vcs_info:(hg*|git*):*' get-revision true
zstyle ':vcs_info:(hg*|git*):*' check-for-changes true

zstyle ':vcs_info:*' stagedstr "${pink}↑"
zstyle ':vcs_info:*' unstagedstr "${brightred}≅"

## (scm) repo hash_changes branch
zstyle ':vcs_info:git*' command /usr/bin/git
zstyle ':vcs_info:git*' formats "${reset}${grey}(%s) ${brightgrey}%r ${brightblue}[%.7i ${brightblue}%b${blue}%m%c%u${brightblue}]${reset}"
zstyle ':vcs_info:git*' actionformats "(%s|%a) %12.2i %c%u %b%m"
#zstyle ':vcs_info:git*' actionformats "(%s|${white}%a${grey}) %12.12i %c%u %b%m"
#zstyle ':vcs_info:(cvs|svn|git|hg):*' branchformat ''
#zstyle ':vcs_info:(cvs|svn|git|hg):*' branchformat ''
zstyle ':vcs_info:git*+set-message:*' hooks git-st git-stash git-untracked

zstyle ':vcs_info:hg:*' formats "(%s) %{[1;30m%}%r${blue} [%b] %i%m%c%u%f${blue}%f "
#zstyle ':vcs_info:hg*' formats "(%s)[%i%u %b %m]" # rev+changes branch misc
zstyle ':vcs_info:hg*' actionformats "(%s|${white}%a${grey})[%i%u %b %m]"
zstyle ':vcs_info:hg*:netbeans' use-simple true
zstyle ':vcs_info:hg*:*' get-bookmarks true
zstyle ':vcs_info:hg*:*' get-mq true
zstyle ':vcs_info:hg*:*' get-unapplied true
zstyle ':vcs_info:hg*:*' patch-format "mq(%g):%n/%c %p"
zstyle ':vcs_info:hg*:*' nopatch-format "mq(%g):%n/%c %p"
#zstyle ':vcs_info:hg*:*' unstagedstr "${green}+${grey}"
zstyle ':vcs_info:hg*:*' hgrevformat "%r" # only show local rev.
zstyle ':vcs_info:hg*:*' branchformat "%b" # only show branch
zstyle ':vcs_info:hg*+set-hgrev-format:*' hooks hg-hashfallback
zstyle ':vcs_info:hg*+set-message:*' hooks mq-vcs hg-storerev hg-branchhead
# zstyle ':vcs_info:hg:*:-all-' command fakehg
zstyle ':vcs_info:hg*+set-hgrev-format:*' hooks hg-hashfallback
zstyle ':vcs_info:hg*+set-message:*' hooks mq-vcs hg-storerev hg-branchhead

zstyle ':vcs_info:cvs:*' formats "%{[1;30m%}%r${blue}%i%m%c%u%f${blue}%f "

zstyle ':vcs_info:svn*' formats "(%s) %{[1;30m%}%r${blue} [%i%b%m%c%u%f%f${reset}%{[1;30m%}${blue}] %f${reset}"
zstyle ':vcs_info:svn:*' branchformat ''

#zstyle ':vcs_info:*' nvcsformats ' '

#zstyle ':vcs_info:*+*:*' debug true

### Store the localrev and global hash for use in other hooks
function +vi-hg-storerev() {
  user_data[localrev]=${hook_com[localrev]}
  user_data[hash]=${hook_com[hash]}
}

### Dynamically set hgrevformat based on if the local rev is available
# We don't always know the local revision, e.g. if use-simple is set
# Truncate long hash to 12-chars but also allow for multiple parents
function +vi-hg-hashfallback() {
  if [[ -z ${hook_com[localrev]} ]] ; then
    local -a parents

    parents=( ${(s:+:)hook_com[hash]} )
    parents=( ${(@r:12:)parents} )
    hook_com[rev-replace]="${(j:+:)parents}"

    ret=1
  fi
}

### Show when mq itself is under version control
function +vi-mq-vcs() {
  # if [[ -d ${hook_com[base]}/.hg/patches/.hg ]]; then
  # hook_com[hg-mqpatch-string]="mq:${hook_com[hg-mqpatch-string]}"
  # fi
}

### Show marker when the working directory is not on a branch head
# This may indicate that running `hg up` will do something
function +vi-hg-branchhead() {
  local branchheadsfile i_tiphash i_branchname
  local -a branchheads

  local branchheadsfile=${hook_com[base]}/.hg/branchheads.cache

  # Bail out if any mq patches are applied
  [[ -s ${hook_com[base]}/.hg/patches/status ]] && return 0

  if [[ -r ${branchheadsfile} ]] ; then
    while read -r i_tiphash i_branchname ; do
      branchheads+=( $i_tiphash )
    done < ${branchheadsfile}

    if [[ ! ${branchheads[(i)${user_data[hash]}]} -le ${#branchheads} ]] ; then
      hook_com[revision]="${red}^${grey}${hook_com[revision]}"
    fi
  fi
}

# Show remote ref name and number of commits ahead-of or behind
function +vi-git-st() {
  local ahead behind remote
  local -a gitstatus

  # Are we on a remote-tracking branch?
  remote=${$(/usr/bin/git rev-parse --verify ${hook_com[branch]}@{upstream} \
    --symbolic-full-name --abbrev-ref 2>/dev/null)}

  if [[ -n ${remote} ]] ; then
    # for git prior to 1.7
    # ahead=$(git rev-list origin/${hook_com[branch]}..HEAD | wc -l)
    ahead=$(/usr/bin/git rev-list ${hook_com[branch]}@{upstream}..HEAD 2>/dev/null | wc -l)
    (( $ahead )) && gitstatus+=( "${green}+${ahead}${blue}" )

    # for git prior to 1.7
    # behind=$(git rev-list HEAD..origin/${hook_com[branch]} | wc -l)
    behind=$(/usr/bin/git rev-list HEAD..${hook_com[branch]}@{upstream} 2>/dev/null | wc -l)
    (( $behind )) && gitstatus+=( "${red}-${behind}${blue}" )

    if [ $behind -gt 0 -o $ahead -gt 0 ]; then
      hook_com[branch]="${brightwhite}${hook_com[branch]} ${brightblue}[${remote} ${(j:/:)gitstatus}]"
    fi
  fi
}

# Show count of stashed changes
function +vi-git-stash() {
  local -a stashes

  if [[ -s ${hook_com[base]}/.git/refs/stash ]] ; then
    stashes=$(/usr/bin/git stash list 2>/dev/null | wc -l)
    hook_com[misc]+=" (${stashes} stashed)"
  fi
}

# Show count of non tracked files
function +vi-git-untracked() {
  local -a untracked

  if [[ ! -z $(/usr/bin/git ls-files --other --exclude-standard 2> /dev/null) ]] {
    untracked=$(/usr/bin/git ls-files --other --exclude-standard 2>/dev/null | wc -l)
    hook_com[misc]+=" (${untracked} untracked)"
    #hook_com[misc]+=" (${untracked} %{[1;31m%}…%F{blue})"
  }
}

# Actualy defines the prompt varaibles.
# %n username
# %m hostname
# %~ current path
# %# prompt symbol
function setprompt() {
  local -a lines infoline
  local x i pet dungeon filler i_width i_pad pathcolor pathprompt

  # A domestic animal, the _tame dog_ (_Canis familiaris_)
  pet=d

  ### First, assemble the top line
  # Current dir; show in yellow if not writable
  [[ -w $PWD ]] && pathcolor=${brightgrey} || pathcolor=${red}

  # Username & host if using ssh
  [ $SSH = 'yes' ] && pathprompt="${brightyellow}@${CHOST}%m"
  infoline+=("${CSTART}%n${pathprompt}${reset} ")

  # Local path
  infoline+=("${brightwhite}[${pathcolor}%~${brightwhite}]")

  datetime="${brightgrey}%T"
  returncode="${brightred}%139(?,SigSegv,%130(?,SigInt,%138(?,SigBus,%134(?,SigAbrt,%?))))"
  jobsnumber="%1(j, ${white}[${brightred}%j${white}],)"
  rprompt="${brightwhite}[%(?,${datetime},${returncode})${jobsnumber}${brightwhite}]"
  infoline+=( " ${rprompt}${white}" )
  # Strip color to find text width & make the full-width filler
  zstyle -T ":pr-nethack:" show-pet && i_pad=4 || i_pad=0

  i_width=${(S)infoline//\%\{*\%\}} # search-and-replace color escapes
  i_width=${#${(%)i_width}} # expand all escapes and count the chars

  filler="${reset}${grey}${(l:$(( $COLUMNS - $i_width - $i_pad ))::.:)}"
  infoline[2]=( "${infoline[2]} ${filler}" )

  ### Now, assemble all prompt lines
  lines+=( ${(j::)infoline} )
  [[ -n ${vcs_info_msg_0_} ]] && lines+=( "${vcs_info_msg_0_}" )
  lines+=( "%(1j.${brightwhite}%j${reset} .)%(0?.${brightwhite}.${red})${brightwhite} %# " )

  ### Add dungeon floor to each line
  # Allow easy toggling of pet display
  if zstyle -T ":pr-nethack:" show-pet ; then
    dungeon=${(l:$(( ${#lines} * 3 ))::.:)}
    dungeon[$[${RANDOM}%${#dungeon}]+1]=$pet

    for (( i=1; i < $(( ${#lines} + 1 )); i++ )) ; do
      case $i in
        1) x=1;; 2) x=4;; 3) x=7;; 4) x=10;;
      esac
      lines[$i]="${brightgrey}${dungeon[x,$(( $x + 2 ))]} ${lines[$i]}${reset}"
    done
  fi

  # Default prompt
  PROMPT=${(F)lines}
  # Right prompt
  #RPROMPT=""
  # Prompt for loops
  PROMPT2='{%_}  '
  # Prompt for selections
  PROMPT3='{ … }  '
  # So far I don't use "setopt xtrace", so I don't need this prompt
  # PROMPT4=''
}

# Turn on color output
if [ $(uname) = FreeBSD ]; then
  export CLICOLOR=true
fi

# bindkeys
# Find keycode:
# execute cat, press the key and crtl + c
bindkey -v
bindkey -M vicmd "^R" redo
bindkey -M vicmd "u" undo
bindkey -M vicmd "k" history-beginning-search-backward
bindkey -M vicmd "j" history-beginning-search-forward
bindkey -M viins '^r' history-incremental-search-backward # crtl-r
bindkey -M vicmd '^r' history-incremental-search-backward # crtl-r

bindkey "^A"    beginning-of-line       # Home
bindkey "^E"    end-of-line             # End
bindkey "^D"    delete-char             # Del
bindkey "[3~" delete-char             # Del
bindkey "[2~" overwrite-mode          # Insert
bindkey "[5~" history-search-backward # PgUp
bindkey "[6~" history-search-forward  # PgDn
#bindkey "^?"    backward-delete-char    # Backspace
bindkey "^?" backward-delete-char

bindkey "[1~" beginning-of-line # Home (console)
bindkey "[4~" end-of-line # End (console)
bindkey "OH" beginning-of-line # Home (gnome-terminal)
bindkey "OF" end-of-line # End (gnome-terminal)
bindkey "[H" beginning-of-line # Home (konsole+xterm)
bindkey "[F" end-of-line # End (konsole+xterm)
bindkey "[A" history-beginning-search-backward
bindkey "[B" history-beginning-search-forward
bindkey "[3;5~" delete-word # Ctrl w
bindkey "[5C" forward-word # Alt ->
bindkey "[1;3C" forward-word # Alt ->
bindkey "^[[C" forward-word
bindkey "[5D" backward-word # Alt <-
bindkey "^[[D" backward-word
bindkey "[1;3D" backward-word # Alt <-
bindkey "[3~" delete-char # Suppr
bindkey "[2~" overwrite-mode # Inser
bindkey "[F" end-of-line
bindkey "[H" beginning-of-line
# bindkey m menu-select
bindkey "h" run-help # esc-h
#bindkey "^M" run-help
# Keycode for up/down in application mode on ubuntu
# http://www.f30.me/2012/10/oh-my-zsh-key-bindings-on-ubuntu-12-10/
bindkey "${terminfo[kcuu1]}" up-line-or-search
bindkey "${terminfo[kcud1]}" down-line-or-search

# urxvt
bindkey "[5" up-line-or-history
bindkey "[6" down-line-or-history
bindkey "[7~" beginning-of-line
bindkey "[8~" end-of-line

# Console linux, dans un screen ou un rxvt
if [ "$TERM" = "linux" -o "$TERM" = "screen" -o "$TERM" = "rxvt" ]
then
  bindkey "[1~" beginning-of-line       # Home
  bindkey "[4~" end-of-line             # End
fi

# xterm
if [ "$TERM" = "xterm" ]
then
  bindkey "[H"  beginning-of-line       # Home
  bindkey "[F"  end-of-line             # End
fi

# Gnome terminal
if [ "$COLORTERM" = "gnome-terminal" ]
then
  bindkey "OH"  beginning-of-line       # Home
  bindkey "OF"  end-of-line             # End
  bindkey "[1;3C" forward-word # Alt ->
  bindkey "[1;3D" backward-word # Alt <-
  bindkey "[1;3A" history-search-backward
fi

# Push a command onto a stack allowing you to run another command first
bindkey '^J' push-line

# Allows editing the command line with an external editor
autoload edit-command-line
zle -N edit-command-line
bindkey -M vicmd "v" edit-command-line

# Alt-S inserts sudo at the starts of the line
insert_sudo () { zle beginning-of-line; zle -U 'sudo ' }
zle -N insert-sudo insert_sudo
bindkey 's' insert-sudo
# }}}

# {{{ environment settings
# zshoptions

REPORTTIME=60       # Report time statistics for progs that take more than a minute to run
WATCH=not-me        # Report any login/logout of other users
WATCHFMT='%n %a %l from %m at %T.'
LOGCHECK=10

# No beeps
unsetopt beep
unsetopt hist_beep
unsetopt list_beep
# force write when using > and file already exists
setopt clobber
# Ctrl+D est équivalent à 'logout'
unsetopt ignore_eof
# Affiche le code de sortie si différent de '0'
setopt print_exit_value
# Demande confirmation pour 'rm *'
unsetopt rm_star_silent
# Try to correct the spelling of commands
setopt correct
# Note the location of each command
setopt hash_cmds
# Whenever a command name is hashed, hash the directory containing it
setopt hash_dirs
# Si on utilise des jokers dans une liste d'arguments, retire les jokers
# qui ne correspondent à rien au lieu de donner une erreur
setopt nullglob
# Assume  '#', '~' and '^' as part of patterns for filename generation
setopt extended_glob
setopt numeric_globsort
setopt bad_pattern # print out an error if a pattern or glob is badly formed
# http://www.zsh.org/mla/workers/1996/msg01463.html
setopt magic_equal_subst
setopt glob_assign

# Do not perform filename completion and expansion when using unquoted =
unsetopt equals

# Completion options
[ -f /etc/zsh/git-flow-completion.zsh ] && source /etc/zsh/git-flow-completion.zsh
[ -f /usr/share/git-flow/git-flow-completion.zsh ] && source /usr/share/git-flow/git-flow-completion.zsh

# Automatically list choices on an ambiguous completion
setopt auto_list
# Complétion
#unsetopt list_ambiguous
# Add a slash after a completed directory name
setopt auto_param_slash
setopt auto_param_keys
# Quand le dernier caractère d'une complétion est '/' et que l'on
# tape 'espace' après, le '/' est effaçé
setopt auto_remove_slash
# Ne fait pas de complétion sur les fichiers et répertoires cachés
unsetopt glob_dots
setopt complete_aliases
#allow tab completion in the middle of a word
setopt complete_in_word
# Autoload, define the user widget and bind incremental-... on TAB.
autoload incremental-complete-word

# Traite les liens symboliques comme il faut
setopt chase_links

# mail checking
MAILCHECK=1
MAIL=$HOME/Mail/INBOX
mailpath=(
"$HOME/Mail/INBOX?You have new mail in INBOX"
)

# Quand l'utilisateur commence sa commande par '!' pour faire de la
# complétion historique, il n'exécute pas la commande immédiatement
# mais il écrit la commande dans le prompt
setopt hist_verify
# Avoid duplicating older command in the history
setopt hist_ignore_dups
# Write history in append mode
setopt append_history
# Perform 'cd' on a directory name if no homonymous command is found
setopt auto_cd
setopt cdable_vars # if cd would fail, because the arg is not a dir, try to expand the argument as if it was called the ~expression way
# L'exécution de "cd" met le répertoire d'où l'on vient sur la pile
setopt auto_pushd
# Ignore les doublons dans la pile
setopt pushd_ignore_dups
# N'affiche pas la pile après un "pushd" ou "popd"
setopt pushd_silent
# "pushd" sans argument = "pushd $HOME"
setopt pushd_to_home

setopt bg_nice # run background jobs at lower priority
# N'envoie pas de "HUP" aux jobs qui tourent quand le shell se ferme
unsetopt hup
setopt auto_resume # resume background task instead of starting new ones
setopt check_jobs # report status of bg-jobs if exiting a shell with job control enabled

# Command history parameters #export HISTORY=1000
# HISTFILE=$HOME/.zshistory
HISTFILESIZE=65536
HISTSIZE=4096
SAVEHIST=$HISTSIZE
# shared history
setopt share_history hist_find_no_dups hist_ignore_all_dups hist_ignore_space

# {{{ completions

#zstyle ':completion:*' use-compctl false
# autorise un caractère sur trois à être une erreur de typo
#zstyle -e ':completion:*:approximate:*' max-errors par 'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'
# formatage et décoration
zstyle ':completion::complete:*' use-cache 1
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
# les extensions de fichier à ne pas proposer (sauf pour rm)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns par '*?.o' '*?.c~' '*?.old' '*?.pro'
zstyle ':completion:*' format '[32m-=> [01m%d[0m'
zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _complete _correct _approximate
# insère toutes les possibilités pour le completer expand
#zstyle ':completion:*:expand:*' tag-order all-expansions
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
case $(uname) in
  Linux)
    eval "`dircolors -b`"
    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
    ;;
  *BSD)
    # Use FreeBSD default colors...
    zstyle ':completion:*' list-colors 'di=34:ln=35:ex=31:cd=36;43:so=32'
    ;;
esac
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=** r:|=**'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=5
zstyle ':completion:*' original true
zstyle ':completion:*' squeeze-slashes true
zstyle -e ':completion:*:(ssh|sssh|scp|sshfs|ping|telnet|ftp|rsync):*' hosts 'reply=(${=${${(M)${(f)"$(<~/.ssh/config)"}:#Host*}#Host }:#*\**})'
zstyle ':completion:*:processes' list-colors '=(#b)(?????)(#B)?????????????????????????????????([^ ]#/)#(#b)([^ /]#)*=00=01;31=01;33'

setopt LIST_TYPES

autoload -U compinit
# }}}

# e.g., zmv *.JPEG *.jpg
autoload -U zmv
alias zmv='noglob zmv'

#compinit
compinit -i ${HOME}/.zcompdump

# name directories
hash -d repos=~/repos
hash -d Desktop=~/Desktop
hash -d Downloads=~/Downloads
hash -d DL=~/Downloads
hash -d Documents=~/Documents
hash -d Docs=~/Documents
hash -d dev=~/dev

[ -x /usr/games/fortune ] && /usr/games/fortune /usr/local/share/games/fortune/bofh
[ -x /usr/bin/fortune ] && fortune bofh-excuses dune hitchhiker heretics-of-dune house-atreides house-harkonnen
echo
[ -x /usr/games/fortune ] && /usr/games/fortune freebsd-tips

#[ ! -h /tmp/.esd-${UID} ] && ln -s /tmp/.esd /tmp/.esd-${UID}

# x autostart
if [ `hostname` = 'htpc' ]; then
  if [ -z "$DISPLAY" ] && [ `tty` = "/dev/tty8" ]; then
    while true; do
      startx
      sleep 10
    done
  fi
fi

function mainClasses {
  if [ -d ./src ] ; then
    find ./src/main -type f -iname "*.java" \
      | sed 's?.*src/main/[^/]*/\(.*\)\..*?-DmainClass=\1?' | sed 's+/+.+g'
  fi
}

function mainTests {
  if [ -d ./src ] ; then
    find ./src/test -type f -iname "*test*.java"  \
      | sed 's?.*src/test/[^/]*/\(.*\)\..*?-Dtest=\1?' | sed 's+/+.+g'
  fi
}

function listMavenCompletions {
  reply=(archetype:generate compile clean package install test
      test-compile deploy release scala:run scala:cc
      -Dmaven.test.skip=true
      `mainClasses`
      `mainTests`
      -q -o
      );
}

compctl -K listMavenCompletions mvn%

# }}}
# Output total memory currently in use by you {{{1

memtotaller() {
  /bin/ps -u $(whoami) -o pid,rss,command | awk '{sum+=$2} END {print "Total " sum / 1024 " MB"}'
}

# }}}
# Miscellaneous Functions:
# ..(), ...() for quickly changing $CWD {{{1
# http://www.shell-fu.org/lister.php?id=769

# Go up n levels:
# .. 3
function .. (){
  local arg=${1:-1};
  local dir=""
  while [ $arg -gt 0 ]; do
    dir="../$dir"
    arg=$(($arg - 1));
  done
  cd $dir >&/dev/null
}

# Go up to a named dir
# ... usr
function ... (){
  if [ -z "$1" ]; then
    return
  fi
  local maxlvl=16
  local dir=$1
  while [ $maxlvl -gt 0 ]; do
    dir="../$dir"
    maxlvl=$(($maxlvl - 1));
    if [ -d "$dir" ]; then
      cd $dir >&/dev/null
    fi
  done
}

# }}}
# {{{ genpass()
# Generates a tough password of a given length

function genpass() {
  if [ ! "$1" ]; then
    echo "Usage: $0 20"
    echo "For a random, 20-character password."
    return 1
  fi
  dd if=/dev/urandom count=1 2>/dev/null | tr -cd 'A-Za-z0-9!@#$%^&*()_+' | cut -c-$1
}

# }}}
# {{{ bookletize()
# Converts a PDF to a fold-able booklet sized PDF
# Print it double-sided and fold in the middle

bookletize () {
  if which pdfinfo && which pdflatex; then
    pagecount=$(pdfinfo $1 | awk '/^Pages/{print $2+3 - ($2+3)%4;}')

    # create single fold booklet form in the working directory
    pdflatex -interaction=batchmode \
      '\documentclass{book}\
      \usepackage{pdfpages}\
      \begin{document}\
      \includepdf[pages=-,signature='$pagecount',landscape]{'$1'}\
      \end{document}' 2>&1 >/dev/null
  fi
}

# }}}
# {{{ joinpdf()
# Merges, or joins multiple PDF files into "joined.pdf"

joinpdf () {
  gs -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=joined.pdf "$@"
}

# }}}

# 256-colors test {{{

256test() {
  echo -e "\e[38;5;196mred\e[38;5;46mgreen\e[38;5;21mblue\e[0m"
}

# }}}
# Dictionary lookup {{{1
# Many more options, see:
# http://linuxcommando.blogspot.com/2007/10/dictionary-lookup-via-command-line.html

dict() {
  curl 'dict://dict.org/d:$1:*'
}

spell() {
  echo $1 | aspell -a
}

# }}}

# EOF
# vim:set ts=2 sw=2 expandtab:
