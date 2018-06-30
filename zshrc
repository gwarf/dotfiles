# ~/.zshrc
# Read by all interactive shells

export LANG="en_US.UTF-8"

# https://dotfiles.github.io/
# HTTps://github.com/zplug/zplug
# https://github.com/unixorn/zsh-quickstart-kit
# http://awesomeawesome.party/awesome-zsh-plugins
# http://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/
# Ideas: https://github.com/mika/zsh-pony
# Testing YADR: http://www.akitaonrails.com/2017/01/10/arch-linux-best-distro-ever

# Requirements
# Incremental search
# l, ls, hub, docker, df/pydf and other useful aliases
# tip on existing alias
# syntax highlighting
# Case insensitive directories completion
# Shrunk path in prompt
# completion (vboxmanage and all other)
# autosuggestions
# improved history
# vim mode
# push-line to use another command before current command
# colored directories
# colored man pages
# auto cd
# ls after cd
# ssh key management
# simple calc
# 256 color
# python venv
# git support
# Fuzzy command line completion

export ZPLUG_HOME=~/.zplug

if [ ! -d "$ZPLUG_HOME" ]; then
  git clone https://github.com/zplug/zplug $ZPLUG_HOME
fi

source "$ZPLUG_HOME/init.zsh"

# Zplug auto update
# XXX Disable to validate if it breaks "special" zplugs such as prezto
# zplug "gwarf/09afddb8741a7ea478ce53aafe20b777", from:gist

# Theme
zplug "bhilburn/powerlevel9k", use:powerlevel9k.zsh-theme
# zplug "caiogondim/bullet-train.zsh", use:bullet-train.zsh-theme, defer:3

zplug "zlsun/solarized-man"

# Aliases and color some command output
zplug "modules/utility", from:prezto
zplug "modules/editor", from:prezto
zplug "modules/history", from:prezto
zplug "modules/tmux", from:prezto
zplug "modules/ssh", from:prezto

zplug "plugins/shrink-path", from:oh-my-zsh
zplug "plugins/taskwarrior", from:oh-my-zsh
zplug "plugins/asdf", from:oh-my-zsh
# A lot of nice aliases
# zplug "plugins/comon-aliases", from:oh-my-zsh
# A fun Half-Life theme
# zplug "themes/half-life", from:oh-my-zsh, defer:3

zplug "zsh-users/zsh-history-substring-search", defer:2
zplug "zsh-users/zsh-completions"
zplug "zsh-users/zsh-autosuggestions"
# To replace autosuggestions
# zplug "hchbaw/auto-fu.zsh", at:pu, defer:1

# XXX Find replacement allowing to disable check for some aliases
zplug "MichaelAquilina/zsh-you-should-use"

zplug "webyneter/docker-aliases", use:docker-aliases.plugin.zsh

# Usage: = 2+2
zplug "arzzen/calc.plugin.zsh"

# Should be loaded after modules/utility to overwrite cd alias
zplug "b4b4r07/enhancd", use:init.sh, defer:3
export ENHANCD_FILTER='fzf'
# When entering a git repo do a git status, othewise do an ls
export ENHANCD_HOOK_AFTER_CD='([ -d .git ] || git rev-parse --git-dir > /dev/null 2>&1) && git st || ls -lhrt'
# export ENHANCD_COMMAND='c'
export ENHANCD_DISABLE_HOME=1
export ENHANCD_DISABLE_HYPHEN=1
export ENHANCD_DISABLE_DOT=1
export ENHANCD_HYPHEN_ARG=_
# Run k when entering a directory

zplug "marzocchi/zsh-notify"

zplug "supercrabtree/k"

zplug "djui/alias-tips"

zplug "chrissicool/zsh-256color"

zplug "zpm-zsh/mysql-colorize"

# XXX Check how to use forward-word with autosuggestions
# Load after modute/editor to enable VI bindings
zplug "sharat87/zsh-vim-mode", defer:3

zplug "zdharma/fast-syntax-highlighting"
# Ctrl-R to search multi word with AND
zplug "zdharma/history-search-multi-word"

# Fuzzy command line completion: Ctrl-T
zplug "junegunn/fzf", use:"shell/*.zsh", defer:2
# Download a binary for FZF if not available locally
# Grab binaries from GitHub Releases
# and rename with the "rename-to:" tag
zplug "junegunn/fzf-bin", \
    from:gh-r, \
    as:command, \
    rename-to:fzf, \
    use:"*linux*amd64*"

zplug "so-fancy/diff-so-fancy", as:command

# Replacement for autojump
zplug "rupa/z", use:"*.sh"

# npm / nvm
#zplug "lukechilds/zsh-nvm"
# [ -f /usr/share/nvm/init-nvm.sh ] && source /usr/share/nvm/init-nvm.sh

# Plugins-specific configuration required before loading them

# prezto
# Color output (auto set to 'no' on dumb terminals).
zstyle ':prezto:*:*' color 'yes'

# prezto/utility
if zplug check modules/utility; then
  # Use safe operations by default
  zstyle ':prezto:module:utility' safe-ops 'yes'
fi

# prezto/editor
if zplug check modules/editor; then
  zstyle ':prezto:module:editor' key-bindings 'vi'
  zstyle ':prezto:module:editor' dot-expansion 'yes'
fi

if zplug check modules/tmux; then
  zstyle ':prezto:module:tmux:auto-start' local 'no'
  zstyle ':prezto:module:tmux:auto-start' remote 'no'
  zstyle ':prezto:module:tmux:session' name 'work'
fi

# Install plugins if there are plugins that have not been installed
if ! zplug check --verbose; then
    printf "Install? [y/N]: "
    if read -q; then
        echo; zplug install
    fi
fi

# Then, source plugins and add commands to $PATH
# zplug load --verbose
zplug load

# Plugins-specific configuration required after loading them

if zplug check zsh-users/zsh-autosuggestions; then
  export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
  bindkey '^ ' autosuggest-accept
fi

if zplug check caiogondim/bullet-train.zsh; then
  BULLETTRAIN_STATUS_EXIT_SHOW=true
  # bullettrain promt: disable nvm and go, show path using custom segment
  BULLETTRAIN_PROMPT_ORDER=(time status context custom perl ruby aws elixir virtualenv git hg cmd_exec_time)
  # Display shunk path in custom prompt segement
  BULLETTRAIN_CUSTOM_MSG='$(shrink_path -f "$PWD")'
  BULLETTRAIN_CUSTOM_BG=blue
  BULLETTRAIN_CUSTOM_FG=white
fi

if zplug "MichaelAquilina/zsh-you-should-use"; then
  export YSU_HARDCORE=0
fi

# ZSH options

# Make sure prompt is able to be generated properly.
setopt prompt_subst

# Executing directories will open them
setopt auto_cd

## Completion

# Hilight directories
zstyle -e ':completion:*:default' list-colors 'reply=("${PREFIX:+=(#bi)($PREFIX:t)(?)*==34=34}:${(s.:.)LS_COLORS}")';

# Rehash when completing commands
zstyle ":completion:*:commands" rehash 1
# Completion menu's navigation with arrows
zstyle ':completion:*' menu select
zstyle ':completion:*:matches' group 'yes'
# let's use the tag name as group name
zstyle ':completion:*' group-name ""
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b'
zstyle ':completion:*:descriptions' format "%{${fg_bold[magenta]}%}= %d =%{$reset_color%}"
# Case insensitive completion
# https://github.com/robbyrussell/oh-my-zsh/blob/master/lib/completion.zsh
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
# zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

#unsetopt correct_all
#setopt menu_complete
#unsetopt flowcontrol
#setopt auto_pushd
#setopt pushd_ignore_dups
#setopt auto_menu
#setopt interactive_comments
#setopt complete_in_word
#setopt promptpercent

# Always use substring search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

bindkey -M vicmd 'j' history-substring-search-down

# In Vi mode use q to allow to use another command before current one
bindkey -M vicmd "q" push-line

# Push a command onto a stack allowing you to run another command first
bindkey '^J' push-line

# Allows editing the command line with an external editor
autoload edit-command-line
zle -N edit-command-line
# Press Esc=v to edit command line
bindkey -M vicmd "v" edit-command-line

# Alt-S inserts sudo at the starts of the line
insert_sudo () { zle beginning-of-line; zle -U '_ ' }
zle -N insert-sudo insert_sudo
bindkey 's' insert-sudo

# named directories
# XXX does not play nice with enhancd
# hash -d repos=~/repos
# hash -d Downloads=~/Downloads
# hash -d Documents=~/Documents
# hash -d GoogleDrive=~/GoogleDrive

export EDITOR='vim'
#export PAGER='less'
export SYSTEMD_PAGER='cat'

#####################################################################
## Shell aliases and functions
#####################################################################

# do not delete / or prompt if deleting more than 3 files at a time
alias rm='rm -I --preserve-root'

# Parenting changing perms on /
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

# k or long listing by default
if command -v "k" >/dev/null 2>&1; then
  alias l='k -h'
  alias l='k -h'
else
  alias l='ls -lh'
fi
## list only directories
alias lsd='ls -d */'
## list only files
alias lsf="ls -rtF | grep -v '.*/'"

alias lsrt='ls -rt'

alias halt='systemctl poweroff'
alias reboot='systemctl reboot'
alias suspend='systemctl suspend'

# Global aliases {{{
alias -g A="| awk"
# Color output using ccze
# XXX ccze -A | less -R
alias -g C="| ccze -A"
alias -g G="| grep"
alias -g GV="| grep -v"
alias -g H="| head"
alias -g L='| $PAGER'
alias -g P=' --help | less'
alias -g R="| ruby -e"
alias -g S="| sed"
alias -g T="| tail"
alias -g V="| vim -R -"
alias -g U=' --help | head'
alias -g W="| wc"
# }}}

# Suffix aliases {{{
alias -s zip=zipinfo
alias -s tgz=gzcat
alias -s gz=gzcat
alias -s tbz=bzcat
alias -s bz2=bzcat
alias -s java=vim
alias -s c=vim
alias -s h=vim
alias -s C=vim
alias -s cpp=vim
alias -s txt=vim
alias -s xml=vim
alias -s html=chromium
alias -s xhtml=chromium
alias -s pdf=okular
alias -s gif=sxiv
alias -s jpg=sxiv
alias -s jpeg=sxiv
alias -s png=sxiv
alias -s bmp=sxiv
alias -s mp3=clementine
alias -s m4a=clementine
alias -s ogg=clementine
# }}

# noremoteglob breaks scp with filenames containing parenthesis
unalias scp
alias scp='noglob scp'

# Sync and update system
alias yupd='yaourt -Syu'
# Force sync and update system
alias yupdf='yaourt -Syyu'
# Remove a package and all related and unused dependencies
alias yrs='yaourt -Rs'
# Remove a package, its dependencies and all the packages that depend on the
# target package - DANGEROUS
alias yrsc='yaourt -Rsc'

alias music='termite --name ncmpcpp -e ncmpcpp'

alias vim=nvim
# Aliases for launching some vimwikis
alias vimnote='vim -c VimwikiMakeDiaryNote'

alias vimwiki='vim -c VimwikiUISelect'
alias vimdiary='vim -c VimwikiDiaryIndex'
alias vimwiki_w='vim -c VimwikiIndex 1'
alias vimwiki_h='vim -c VimwikiIndex 2'

alias dashboard="vim -p -c TW -c 'VimwikiTabIndex 1' -c 'VimwikiTabIndex 2'"

alias alot_work='alot -p ~/Mail -l ~/.config/alot/alot.log'

# Cal conf
# Start week on Monday
alias cal='cal -m'

# Google Calenar
alias gcal-week='gcalcli --width 12 calw'
alias gcal='gcalcli --width 12 calm'
alias gcal-add='gcalcli quick'
alias gcal-agenda='gcalcli agenda'

# Home-related tasks
alias th='task rc:~/.taskrc-home'

if (( $+commands[hub] )); then
  alias git=hub
fi

# TODO check that vboxmanage completion is available
# /usr/share/zsh/site-functions/_virtualbox
if (( $+commands[compdef] )); then
  if (( $+commands[VBoxManage] )); then
    compdef vboxmanage=VBoxManage
    compdef vboxheadless=VBoxHeadless
  fi
fi

# Completion for hexo
if (( $+commands[hexo] )); then
  eval "$(hexo --completion=zsh)"
fi

xev() {
  command xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

drun() {
  command docker run --rm -v $(pwd):/source -it "$1"
}

# Colorize output using ccze
journalctl() {
  command journalctl $@ | ccze -A
}

last() {
  command last $@ | ccze -A
}

free() {
  command free $@ | ccze -A
}

activate() {
    . $1/bin/activate
}

# XXX currently in cron
# XXX launch this from xinitrc/i3 to ensure that it's called only in X
# if [ -x /usr/bin/gcalcli ]; then
#   while true; do
#     /usr/bin/gcalcli --calendar="davis" remind
#     sleep 300
#   done &
# fi

# scan the local network and list the connected devices
lscan() {
    local ipRange=$(ip addr | grep -oE "192.168.*.*/[1-9]{2}" | awk -F '.' '{print $3}')
    local scanReport=$(nmap -sn "192.168.$ipRange.1-254/24" | egrep "scan report")
    # echo "$scanReport\n" | sed -r 's#Nmap scan report for (.*) \((.*)\)#\1 \2#'
    printf "$scanReport\n"
}

listdirectories() {
    # TODO: Ignore .git, node_modules, etc
    find -L . -type d -print -o -type l -print -o \
        \( -path '*/\.*' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \) -prune \
        2> /dev/null | \
        grep -v '^.$' | \
        sed 's|\./||g' | \
        fzf-tmux --ansi --multi --tac --preview-window right:50% \
            --preview 'tree -C {} | head -$LINES'
}

project-switcher() {
    local projects proj

    projects="$(realpath ~/Projects/)"
    proj=$(find -L "$projects" -maxdepth 1 -type d -printf "%f\n" -o -type l -printf "%f\n" -o -prune \
        2> /dev/null | \
        grep -v '^.$' | \
        sed 's|\./||g' | \
        fzf-tmux --ansi --multi --tac --preview-window right:50% \
            --preview "echo 'Branches\n' && git -C $projects/{} rev-parse HEAD > /dev/null 2>&1 &&
                git -C $projects/{} branch -vv --color=always &&
                echo '\n\nCommits\n' && git -C $projects/{} l -10 | head -$LINES") || return

    cd $projects/$proj
}

# export SHELL='/usr/bin/zsh -l'

# https://nurdletech.com/linux-notes/agents/keyring.html
# https://faq.i3wm.org/question/4126/sessions-environment-variables/index.html%3Fanswer=4130.html#post-id-4130
# https://askubuntu.com/questions/138892/how-can-i-permanently-save-a-password-protected-ssh-key
# https://faq.i3wm.org/question/2498/ssh-sessions-in-i3.1.html
# XXX debug with systemd-alanlyze, bootchard...
# https://wiki.archlinux.org/index.php/Improving_performance/Boot_process
# if [ -n "$DESKTOP_SESSION" ];then
# XXX keyring seems to be already running but without all the components
#     eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gnupg)
#     export SSH_AUTH_SOCK
# fi
# Keyring started by LightDM with PAM:
# /etc/pam.d/lightdm
# XXX Destop files
# /etc/xdg/autostart/gnome-keyring-*.desktop

# XXX Caller is always /bin/zsh
# LOG="$HOME/profile-invocations"
# echo "-----" >>$LOG
# echo "Caller 1: $0" >>$LOG
# echo "DESKTOP_SESSION 1: $DESKTOP_SESSION" >>$LOG

# if [ "$0" = "/usr/sbin/lightdm-session" -a "$DESKTOP_SESSION" = "i3" ]; then
if [ -n "$DESKTOP_SESSION" -a "$DESKTOP_SESSION" = "i3" ]; then
    export $(gnome-keyring-daemon -s)
fi
# source ~/bin/start-gnome-keyring.sh

# Archlinux command not found (needs pkgfile)
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
  . /usr/share/doc/pkgfile/command-not-found.zsh
fi

[ -f ~/.appdb-env.sh ] && . ~/.appdb-env.sh

[ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

# Source secrets if existing
[ -f ~/.secrets.zsh ] && . ~/.secrets.zsh

# Source local zsh conf if existing
[ -f ~/.local.zsh ] && . ~/.local.zsh
