#!/bin/bash
osascript - "$@" <<EOF
on run argv
tell application "iTerm"
    activate
    set new_term to (create window with default profile)
    tell new_term
        tell the current session
            repeat with arg in argv
               write text arg
            end repeat
        end tell
    end tell
end tell
end run
EOF
