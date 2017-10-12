# ~/.zlogin

# display system informations
uname -a
uptime

# Display tasks
if $(type task &> /dev/null); then
  printf '\n'
  tw next
fi

# Display reminds
# if $(type remind &> /dev/null); then
#   printf '\n'
#   remind -f ~/.reminders
# fi

# Print a random, hopefully interesting, adage.
if (( $+commands[fortune] )); then
  printf '\n'
  fortune -a
  print
fi
