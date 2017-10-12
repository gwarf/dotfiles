# ~/.zshenv
# Read by all shells

# Warning: before reading ~/.zprofile zsh reads:
# - /etc/zprofile that reads /etc/profile and defines a default path
typeset -U path
path=(~/bin $path[@])
