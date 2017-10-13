# ~/.zlogin

# display system informations
# uname -a
# uptime

# Display tasks
if $(type task &> /dev/null); then
  printf '\n'
  task due today
fi

# Display reminds
# if $(type remind &> /dev/null); then
#   printf '\n'
#   remind -f ~/.reminders
# fi

# Print Google calendar agenda
if (( $+commands[gcalcli] )); then
  gcalcli --calendar baptiste.grenier@egi.eu agenda
fi

# Print a random, hopefully interesting, adage.
if (( $+commands[fortune] )); then
  printf '\n'
  fortune -a
  printf '\n'
fi
