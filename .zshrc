# ~/.zshrc
# Read by all interactive shells

# Requirements {{{
# Incremental search
# l, ls, gh, docker, df/pydf and other useful aliases
# syntax highlighting
# Case insensitive directories completion
# Shrunk path in prompt
# completion (vboxmanage and all other)
# Fuzzy command line completion
# autosuggestions
# improved history
# vim mode
# push-line to use another command before current command
# colored directories
# colored man pages
# auto cd
# ls after cd
# ssh key management
# 256 color / true color
# git support
# python venv
# }}}

# References {{{
# https://dotfiles.github.io/
# https://github.com/unixorn/zsh-quickstart-kit
# https://zdharma-continuum.github.io/zinit/wiki/Example-Oh-My-Zsh-setup/
# http://awesomeawesome.party/awesome-zsh-plugins
# https://github.com/unixorn/awesome-zsh-plugins
# http://reasoniamhere.com/2014/01/11/outrageously-useful-tips-to-master-your-z-shell/
# Ideas: https://github.com/mika/zsh-pony
# Testing YADR: http://www.akitaonrails.com/2017/01/10/arch-linux-best-distro-ever
# https://zdharma-continuum.github.io/zinit/wiki/GALLERY/

# ZSH plugin framework: zinit https://github.com/zdharma-continuum/zinit
# https://zdharma-continuum.github.io/zinit/wiki
# Cleaning everything
# zi delete --all --yes; unset $_comps
# rm -rf ~/.local/share/zinit; exec zsh -l
# }}}

# Dependencies {{{
# - bat: cat/less replacement
# - gam: CLI for G Suite
# - git
# - cli: GitHub CLI (installed automatically)
# - nvim: vim replacement
# - pydf: df replacement (optional)
# - taskwarrior: task management (optional)
# - fd: find replacement (installed automatically)
# - jq: json formatting/queryring (installed automatically)
# - fzf: fuzzyfinder (installed automatically)
# }}}


# Windows {{{
if [[ -f "/mnt/c/WINDOWS/system32/wsl.exe" ]]; then
    # We're in WSL, which defaults to umask 0 and causes issues with compaudit
    umask 0022
    if [[ "${PWD}" = "/mnt/c/Users/${USER}" ]]; then
        # We're in a default WSL shell
        cd "${HOME}"
    fi
fi
# }}}

# Enable Powerlevel10k instant prompt. {{{
# Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# }}}

### Added by Zinit's installer {{{
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
# }}}

# Style {{{
# Fonts
# Hack Regular Nerd Font Complete
# https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hack
# A font with ligatures
# https://github.com/tonsky/FiraCode
# Powerlevel10k: https://github.com/romkatv/powerlevel10k
# Load powerlevel10k theme
# git clone depth
zinit ice depth"1"
zinit light romkatv/powerlevel10k

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Enable multicolor terminal, if available
zinit light chrissicool/zsh-256color

# XXX dircolors comes from brew/coreutils on Mac OS X
# zinit ice atclone"dircolors -b LS_COLORS > clrs.zsh" \
    #         atpull"%atclone" pick"clrs.zsh" nocompile'!'
# zinit light trapd00r/LS_COLORS

# Nordic dircolors configuration
# https://github.com/arcticicestudio/nord-dircolors
# zinit ice atclone"dircolors -b src/dir_colors > c.zsh" \
    #             atpull'%atclone' \
    #             pick"c.zsh" \
    #             nocompile'!'
# zinit light arcticicestudio/nord-dircolors

zinit ice atclone"dircolors -b .dircolors > c.zsh" \
    atpull'%atclone' \
    pick"c.zsh" \
    nocompile'!'
zinit light dracula/dircolors
# }}}

# Modules from prezto {{{
# https://github.com/sorin-ionescu/prezto/
# Color output (auto set to 'no' on dumb terminals).
zstyle ':prezto:*:*' color 'yes'
# Rehash when completing commands
zstyle ":completion:*:commands" rehash 1
zinit snippet PZTM::environment
# Provides interactive use of GNU utilities on BSD systems
zinit snippet PZTM::gnu-utility
# Provides an easier use of GPG by setting up gpg-agent.
# zinit snippet PZTM::gpg
# Sets directory options and defines directory aliases.
zinit snippet PZTM::directory
# Completion
zinit snippet PZTM::completion
# Aliases and color some command output
zstyle ':prezto:module:editor' key-bindings 'vi'
zstyle ':prezto:module:editor' dot-expansion 'yes'
zstyle ':prezto:module:editor' ps-context 'yes'
zinit snippet PZTM::editor
# Use safe operations by default
zstyle ':prezto:module:utility' safe-ops 'yes'
zinit snippet PZTM::utility
# Manage history configuration
zinit snippet PZTM::history
zinit snippet PZT::modules/terminal/init.zsh
zstyle ':prezto:module:terminal' auto-title 'yes'
if (( $+commands[tmux] )); then
    zstyle ':prezto:module:tmux:auto-start' local 'no'
    zstyle ':prezto:module:tmux:auto-start' remote 'yes'
    zstyle ':prezto:module:tmux:session' name 'work'
    zstyle ':prezto:module:tmux:iterm' integrate 'no'
    zinit snippet PZTM::tmux
fi
# }}}

# Modules from oh-my-zsh {{{
# https://zdharma-continuum.github.io/zinit/wiki/Example-Oh-My-Zsh-setup/
# System clipboard integration
zinit snippet OMZL::clipboard.zsh
if (( $+commands[task] )); then
    zinit snippet OMZP::taskwarrior
    # Home-related tasks
    alias th='task rc:~/.taskrc-home'
fi
if (( $+commands[vagrant] )); then
    zinit snippet OMZP::vagrant
fi
if [[ "$OSTYPE" == "darwin"* ]]; then
    # This requires having subversion installed
    zinit ice svn
    zinit snippet OMZP::macos
fi
# }}}

# Completion definitions
zinit ice wait'0' blockf lucid
zinit light zsh-users/zsh-completions

# Install various tools from GitHub {{{
# fzf, ripgrep, fd, jq, bat, lsd and delta
zinit from"gh-r" as"program" lucid for \
    sbin"**/bat -> bat" @sharkdp/bat \
    sbin"jq* -> jq" stedolan/jq \
    sbin"**/fd" atclone'cp -vf **/autocomplete/_fd _fd' @sharkdp/fd \
    sbin'**/lsd -> lsd' atclone'cp -vf **/autocomplete/_lsd _lsd' Peltoche/lsd \
    sbin'**/delta -> delta' dandavison/delta \
    sbin"**/bin/gh -> gh" cli/cli \
    mv"ripgrep* -> rg" pick"rg/rg" BurntSushi/ripgrep \
    mv"delta* -> delta" pick"delta/delta" dandavison/delta \
    mv"tree-sitter* -> tree-sitter" tree-sitter/tree-sitter \
    junegunn/fzf
# }}}

# FZF {{{
# Fuzzy command line completion: Ctrl-T
# Fuzzy command line history search: Ctrl-R
# Grab initialisation files and get fzf-tmux from GitHub repo
zinit ice lucid wait"0" as'program' id-as"junegunn/fzf-extras" \
    multisrc"shell/{completion,key-bindings}.zsh" \
    pick"bin/fzf-tmux"
zinit light junegunn/fzf

# Completion for openstack, docker and terraform
zinit wait'1' as"completion" lucid for \
    https://github.com/docker/cli/blob/master/contrib/completion/zsh/_docker \
    https://gist.github.com/gwarf/a18dbeaa01d6cf14a95c31a1c7036f61/raw

# tab completion using fzf
# https://github.com/Aloxaf/fzf-tab
zinit ice wait lucid blockf
zinit light Aloxaf/fzf-tab
# disable sort when completing `git checkout`
zstyle ':completion:*:git-checkout:*' sort false
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
# preview directory's content with lsd when completing cd
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'lsd --oneline --icon always --color always $realpath'
# switch group using `,` and `.`
zstyle ':fzf-tab:*' switch-group ',' '.'

# fzf-marks: manage marks with mark
# Add a mark in fzf using Ctrl-g, jump to a match using ctrl-y
# toggle for deletion using ctrl-t delete using ctrl-d
# use git <command> **
# https://github.com/wfxr/forgit
zinit wait lucid blockf for \
    urbainvaes/fzf-marks \
    wfxr/forgit
# }}}

# https://github.com/jeffreytse/zsh-vi-mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

# fast-syntax-highlighting and autosuggestions
# Theme management: fsh-alias -h
zinit wait lucid for \
    atload"_zsh_autosuggest_start" zsh-users/zsh-autosuggestions \
    atinit"zpcompinit;zpcdreplay" zdharma-continuum/fast-syntax-highlighting \
    hlissner/zsh-autopair
export ZSH_AUTOSUGGEST_STRATEGY=(history completion)
# Accept autosuggestion using Ctrl-space
bindkey '^ ' autosuggest-accept

# Substring search in history
zinit light zsh-users/zsh-history-substring-search
zmodload zsh/terminfo
# Try to catch many different keys
# https://github.com/zsh-users/zsh-history-substring-search/issues/64
bindkey '[A' history-substring-search-up
bindkey '[B' history-substring-search-down
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '\eOA' history-substring-search-up # or ^[OA
bindkey '\eOB' history-substring-search-down # or ^[OB
[ -n "${terminfo[kcuu1]}" ] && bindkey "${terminfo[kcuu1]}" history-substring-search-up
[ -n "${terminfo[kcud1]}" ] && bindkey "${terminfo[kcud1]}" history-substring-search-down
bindkey -M emacs '^P' history-substring-search-up
bindkey -M emacs '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

if (( $+commands[mysql] )); then
    zinit light "zpm-zsh/mysql-colorize"
fi

# npm / nvm
# export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
export NVM_NO_USE=false
zinit ice wait lucid
zinit light lukechilds/zsh-nvm

# A smarter cd command
# XXX feature for chpwd hook is not yet released as of 2022-11-06 (0.8.3)
# FIXME install from master/cargo
# https://github.com/ajeetdsouza/zoxide/pull/474
# zinit ice wait"2" as"command" from"gh-r" lucid \
    #      atclone"./zoxide init zsh --cmd cd > init.zsh" \
    #      atpull"%atclone" src"init.zsh" nocompile'!'
# zinit light ajeetdsouza/zoxide

# Run git status or ls when entering a directory
autoload -Uz add-zsh-hook
function custom_chpwd() {
    if [[ -d ".git" ]] || git rev-parse --git-dir > /dev/null 2>&1; then
        git st
    fi
    lsd --icon always --color always
}
add-zsh-hook chpwd custom_chpwd

# Python virtualenv management {{{
#
# pyenv
#
# Checking available python versions
# pyenv install -l
# Checking installed python versions
# pyenv versions
# Installing a python version
# pyenv install 3.10.7
# Checking current python version
# pyenv version
# Setting default version
# pyenv global 2.7.18 3.10.7
# Setting directory specific version
# pyenv local 3.10.7
#
# https://github.com/zdharma-continuum/zinit-packages/tree/main/pyenv
zinit as'null' lucid  atinit'export PYENV_ROOT="$PWD"' \
    atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
    atpull"%atclone" src"zpyenv.zsh" nocompile'!' sbin"bin/pyenv" for \
    pyenv/pyenv

# https://github.com/MichaelAquilina/zsh-autoswitch-virtualenv
# virtualenvs are stored in ~/.virtualenvs
#
# Creating a venv manually
# pyenv local 3.10.7
# python3 -m venv ~/.virtualenvs/impact-report
# source ~/.virtualenvs/impact-report/bin/activate
# echo 'impact-report' > .venv
zinit light MichaelAquilina/zsh-autoswitch-virtualenv
# }}}

# asdf: https://github.com/asdf-vm/asdf
# git clone https://github.com/asdf-vm/asdf.git ~/.asdf
# asdf plugin-add python https://github.com/tuvistavie/asdf-python.git
# asdf plugin list-all python
# asdf plugin install python 2.7
# zplug "plugins/asdf", from:oh-my-zsh
# https://github.com/kiurchv/asdf.plugin.zsh
# zplug "kiurchv/asdf.plugin.zsh", defer:2

# Perlbrew
zinit ice wait"1" lucid
zinit light tfiala/zsh-perlbrew

# GPG management
zinit ice wait"1" lucid
zinit light laggardkernel/zsh-gpg-agent

# ZSH options {{{

autoload -Uz compinit

if [ $(date +'%j') != $(date -r ${ZDOTDIR:-$HOME}/.zcompdump +'%j') ]; then
    compinit;
else
    compinit -C;
fi

# -q is for quiet; actually run all the `compdef's saved before `compinit` call
# (`compinit' declares the `compdef' function, so it cannot be used until
# `compinit' is ran; Zinit solves this via intercepting the `compdef'-calls and
# storing them for later use with `zinit cdreplay')
zinit cdreplay -q

# Enable zmv
autoload -U zmv

# Make sure prompt is able to be generated properly.
# Required for themes like bullet-train
setopt prompt_subst

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
# }}}

# Preferred editor for local and remote sessions
if (( $+commands[nvim] )); then
    export EDITOR='nvim'
    export MANPAGER='nvim +Man!'
    alias vim='nvim'
    alias vi='nvim'
    alias vimdiff='nvim -d'
else
    export EDITOR='vim'
fi

# Aliases and functions {{{
if (( $+commands[msfconsole] )); then
    alias msfconsole='msfconsole --quiet'
fi

# --preserver-root is for GNU versions
# do not delete / or prompt if deleting more than 3 files at a time
alias rm='nocorrect rm -i --preserve-root'

# Preventing changing perms on /
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'

alias ls='lsd --group-dirs first'
alias lt='ls --tree'
alias l='ls -l'
alias la='ls -a'
alias lla='ls -la'
# list only directories
alias lsdir='ls -d */'
# list only files
alias lsfiles="ls -rtF | grep -v '.*/'"

# Suffix aliases
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
alias -s html=firefox
alias -s xhtml=firefox
# alias -s pdf=okular
if (( $+commands[sxiv] )); then
    alias -s gif=sxiv
    alias -s jpg=sxiv
    alias -s jpeg=sxiv
    alias -s png=sxiv
    alias -s bmp=sxiv
fi
if (( $+commands[clementine] )); then
    alias -s mp3=clementine
    alias -s m4a=clementine
    alias -s ogg=clementine
fi

# Aliases for launching some vimwikis
alias vimnote='vim -c VimwikiMakeDiaryNote'
alias vimwiki='vim -c VimwikiUISelect'
alias vimdiary='vim -c VimwikiDiaryIndex'
alias vimwiki_w='vim -c VimwikiIndex 1'
alias vimwiki_h='vim -c VimwikiIndex 2'
alias dashboard="vim -p -c TW -c 'VimwikiTabIndex 1' -c 'VimwikiTabIndex 2'"

# Color iproute2 output
alias ip='ip -color=auto'

# Use pydf if available
if (( $+commands[pydf] )); then
    alias df=pydf
fi

if (( $+commands[rlwrap] )); then
    alias listener="sudo rlwrap nc -lvnp 443"
fi

xev() {
    command xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
}

drun() {
    command docker run --rm -v $(pwd):/source -it "$1"
}

alias stack='docker run -it --rm -v ~/.stack:~/.stack gbraad/openstack-client:centos stack'

# scan the local network and list the connected devices
lscan() {
    local ipRange=$(ip addr | grep -oE "192.168.*.*/[1-9]{2}" | awk -F '.' '{print $3}')
    local scanReport=$(nmap -sn "192.168.$ipRange.1-254/24" | egrep "scan report")
    # echo "$scanReport\n" | sed -r 's#Nmap scan report for (.*) \((.*)\)#\1 \2#'
    printf "$scanReport\n"
}

if [ -x "$HOME/bin/gamadv-xtd3/gam" ]; then
    # CLI for Google admin, updated GAM
    # https://github.com/taers232c/GAMADV-XTD3
    # gam() { "$HOME/bin/gamadv-xtd3/gam" "$@" ; }
    PATH="$HOME/bin/gamadv-xtd3/:$PATH"
    alias gam="$HOME/bin/gamadv-xtd3/gam"
fi
# }}}
#
if (( $+commands[colordiff] )); then
    alias diff="colordiff"
fi

# Ensure that appropriate env var are set for gnome-keyring SSH agent
if [ -n "$DESKTOP_SESSION" ]; then
    if [ "$DESKTOP_SESSION" = "i3" -o "$DESKTOP_SESSION" = 'xinitrc' ]; then
        export $(gnome-keyring-daemon -s)
    fi
fi

# Archlinux command not found (needs pkgfile)
if [ -f /usr/share/doc/pkgfile/command-not-found.zsh ]; then
    . /usr/share/doc/pkgfile/command-not-found.zsh
fi

# added by travis gem
[ -f ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# Source secrets if existing
[ -f ~/.secrets.zsh ] && source ~/.secrets.zsh
[ -f ~/.secrets ] && source ~/.secrets
[ -f ~/.appdb-env.sh ] && source ~/.appdb-env.sh

# Load RVM into a shell session *as a function*
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"

# XXX to be tested/documented
if (( $+commands[oidc-agent-service] )); then
    eval $(oidc-agent-service use)
    # for fedcloudclient, once egi account got created
    export OIDC_AGENT_ACCOUNT=egi
fi

if (( $+commands[misfortune] )); then
    misfortune -o
elif (( $+commands[fortune] )); then
    if (( $+commands[cowsay] )); then
        fortune | cowsay
    else
        fortune
    fi
fi

# Env variables {{{
# macOS conf
if [[ "$OSTYPE" == darwin* ]]; then
    # Use gnused - brew install gnu-sed
    PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
    # Use coreutils GNU utilities - brew install coreutils
    PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"
    # Use openjdk from brew - brew install openjdk
    PATH="/usr/local/opt/openjdk/bin:$PATH"
    export HOMEBREW_CASK_OPTS='--no-quarantine'
    export HOMEBREW_NO_ANALYTICS=1

    # Add go to the path
    if [ -d "$HOME/go" ]; then
        export GOPATH="$HOME/go"
        export GOBIN="$GOPATH/bin"
        export GOROOT=/usr/local/opt/go/libexec
        # For github.com/raviqqe/liche
        export GO111MODULE=on
        export PATH="$PATH:$GOBIN"
        export PATH="$PATH:$GOROOT/bin"
    fi

    # https://github.com/pyenv/pyenv/wiki/Common-build-problems
    # Required for building python with pyenv on Mac OS X
    CFLAGS="-I/usr/local/opt/openssl/include -I/usr/local/opt/zlib/include -I/usr/local/opt/sqlite/include"
    LDFLAGS="-L/usr/local/opt/openssl/lib -L/usr/local/opt/zlib/lib -L/usr/local/opt/sqlite/lib"
    if [ -d "/usr/local/opt/llvm" ]; then
        # Favor using llvm stuff from homebrew
        CPPFLAGS="-I/usr/local/opt/llvm/include"
        LDFLAGS="-L/usr/local/opt/llvm/lib ${LDFLAGS}"
        LDFLAGS="-L/usr/local/opt/llvm/lib/c++ -Wl,-rpath,/usr/local/opt/llvm/lib/c++ ${LDFLAGS}"
        PATH="/usr/local/opt/llvm/bin:${PATH}"
    fi
    # Use clang
    CC=clang
    CXX=clang++
    # Speeding up build
    CFLAGS="-O2 ${CFLAGS}"
    export CC CXX CFLAGS LDFLAGS CPPFLAGS
    # PYTHON_CONFIGURE_OPTS=--enable-unicode=ucs2

    # tail-like of postfix logs on MacOS X
    postfix_log() {
        log stream --predicate '(process == "smtpd") || (process == "smtp") || (process == "master")' --info
    }

    # https://apple.stackexchange.com/questions/3253/ctrl-o-behavior-in-terminal-app
    # To prevent ctrl-o in vim being discared by the terminal driver
    # XXX returning error with updated conf
    # stty: 'standard input': Operation not supported by device
    # stty discard undef

    # cd into whatever is the forefront Finder window.
    cdf() {  # short for cdfinder
        cd "`osascript -e 'tell app "Finder" to POSIX path of (insertion location as alias)'`"
    }
fi

export MAKEOPS='j6'

# Path management
typeset -U path
path+=/usr/local/sbin
if [ -d "$HOME/bin" ]; then
    PATH="$HOME/bin:$PATH"
fi
if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi
if [ -d "$HOME/.yarn/bin" ]; then
    PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
fi
# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [ -d "$HOME/.rvm/bin" ]; then
    PATH="$HOME/.rvm/bin:$PATH"
fi
export PATH

# Mail storage
export MAILDIR=~/Mail

# Preferred terminal
if (( $+commands[kitty] )); then
    export TERMINAL='kitty'
fi

if (( $+commands[bat] )); then
    export SYSTEMD_PAGER='bat'
    alias less=bat
    alias cat='bat --paging=never'
    alias more=bat
    # Fallback as man pager
    if [ -z "$MANPAGER" ]; then
        export MANPAGER="sh -c 'col -bx | bat -l man -p'"
    fi
    export BAT_THEME='Dracula'
else
    export SYSTEMD_PAGER='cat'
fi

# Manually set language environment
LC_ALL=en_GB.UTF-8
LANG=en_GB.UTF-8
export LC_ALL LANG

# FZF configuration
# export FZF_DEFAULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*" 2> /dev/null'
export FZF_DEFAULT_COMMAND='ag -l --path-to-ignore ~/.ignore --nocolor --hidden -g ""'
export FZF_DEFAULT_OPTS="--reverse --exit-0 --border --ansi"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd -t d ."
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || bat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# }}}

# Nix
# if [[ -f "${HOME}/.nix-profile/etc/profile.d/nix.sh" ]]; then
#   source "${HOME}/.nix-profile/etc/profile.d/nix.sh"
# fi

# vim:foldlevel=0 foldmethod=marker
