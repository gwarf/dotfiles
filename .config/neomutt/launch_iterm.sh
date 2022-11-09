#!/bin/bash
osascript - "$@" <<EOF
on run input
  set cmd to "nvim " & quote & input & quote & " && exit"
  tell application "iTerm"
    activate
    set new_term to (create window with default profile)
    tell new_term
      tell the current session
         write text cmd
      end tell
    end tell
  end tell
end run
EOF
