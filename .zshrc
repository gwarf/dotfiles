# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Source system profile
emulate sh -c 'source /etc/profile'

eval "`dircolors -b`"

# Gem on archlinux
if [ -d "$HOME/.gem/ruby/2.0.0/bin" ]; then
  PATH="/home/baptiste/.gem/ruby/2.0.0/bin:$PATH"
  export GEM_HOME="$HOME/.gem/ruby/2.0.0"
fi

[ -f ~/.zshenv ] && source ~/.zshenv
[ -f ~/.alias ] && source ~/.alias

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="blinks"
#ZSH_THEME="sunrise"
#ZSH_THEME="intheloop"

# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Set to this to use case-sensitive completion
CASE_SENSITIVE="false"

# Uncomment this to disable bi-weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment to change how often before auto-updates occur? (in days)
# export UPDATE_ZSH_DAYS=13

# Uncomment following line if you want to disable colors in ls
DISABLE_LS_COLORS="false"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want to disable command autocorrection
#DISABLE_CORRECTION="true"
ENABLE_CORRECTION="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
# COMPLETION_WAITING_DOTS="true"

# Uncomment following line if you want to disable marking untracked files under
# VCS as dirty. This makes repository status check for large repositories much,
# much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment following line if you want to  shown in the command execution time stamp 
# in the history command output. The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|
# yyyy-mm-dd
HIST_STAMPS="mm/dd/yyyy"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(colorize colored-man gitfast git-flow archlinux bundler command-not-found gem history-substring-search mvn rake ruby tmux svn terminator urltools vagrant vi-mode vundle web-search sysadmin common-aliases rvm)

source $ZSH/oh-my-zsh.sh

source ~/.zsh-theme.baptiste

# User configuration

export PATH=$HOME/bin:/usr/local/bin:$PATH
# export MANPATH="/usr/local/man:$MANPATH"
[ -x /usr/bin/fortune ] && fortune -a && echo
# name directories
hash -d repos=~/repos
hash -d Desktop=~/Desktop
hash -d Downloads=~/Downloads
hash -d DL=~/Downloads
hash -d Documents=~/Documents
hash -d Docs=~/Documents
hash -d dev=~/dev
hash -d maatpuppet=~/repos/maatG/fr.maatg/infrastructure/puppet

# Alt-S inserts sudo at the starts of the line
insert_sudo () { zle beginning-of-line; zle -U 'sudo ' }
zle -N insert-sudo insert_sudo
bindkey 's' insert-sudo
# }}}

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
#bindkey "${terminfo[kcuu1]}" up-line-or-search
#bindkey "${terminfo[kcud1]}" down-line-or-search

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

# Command history parameters
#export HISTORY=1000
HISTFILE=$HOME/.zshistory
HISTFILESIZE=65536
HISTSIZE=4096
SAVEHIST=$HISTSIZE
# shared history
setopt share_history hist_find_no_dups hist_ignore_all_dups hist_ignore_space

# Completion options
#[ -f /etc/zsh/git-flow-completion.zsh ] && source /etc/zsh/git-flow-completion.zsh
#[ -f /usr/share/git-flow/git-flow-completion.zsh ] && source /usr/share/git-flow/git-flow-completion.zsh

# # Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

autoload -U zmv

PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
