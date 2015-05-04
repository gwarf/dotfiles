# zsh config file

## Execute code that does not affect the current session in the background.
#{
#  # Compile the completion dump to increase startup speed.
#  zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
#  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
#    zcompile "$zcompdump"
#  fi
#} &!

# display system informations
uname -a
uptime
echo
if $(type task &> /dev/null); then
  printf 'Tasks:\n'
  task list
fi
if $(type remind &> /dev/null); then
  printf 'Reminds:\n'
  remind -f ~/.reminders
fi

# Allow messaging from other users
mesg y

# Turn on numpad on the console
#case "`tty`" in /dev/tty[1-6]*)
#    setleds +num
#esac

if [ $(hostname) != 'htpc'  ]; then
  # tmux
  if which tmux 2>&1 >/dev/null; then
    # if not inside a tmux session
    # and if no session is started, start a new session
    if [ -z "$TMUX" ]; then
      # Start default session if not found
      if ! tmux has-session -t home; then
        logger 'no session!'
        [ -x ~/bin/tmux-default-session ] && (~/bin/tmux-default-session)
      fi
      # No more automatically attach session
      #(tmux attach -t home)
    fi
    #test -z "$TMUX" && (tmux attach || ~/bin/tmux-new-session)
  fi
fi

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*

## Print a random, hopefully interesting, adage.
#if (( $+commands[fortune] )); then
#  fortune -a
#  print
#fi
