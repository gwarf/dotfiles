#!/bin/bash
# https://github.com/NoSuck/MuttMailto
# xdg-mime default mutt-mailto.desktop x-scheme-handler/mailto

# NoSuck.org
# Mutt Mailto Handler for XDG Environment

if [[ "$1" == mailto:* ]] ; then
  sStart="${1%%\?*}"
  sEnd="&${1##*\?}"
  # The whitelist.
  sValidAttributes=( "Subject" "Body" "Cc" )
  for sAttribute in "${sValidAttributes[@]}" ; do
    sHit="$( echo "$sEnd" | sed "s/^.*&$sAttribute=\([^&]*\).*/$sAttribute=\1/" )"
    if [[ "$sEndNew" ]] ; then
      sEndNew="$sEndNew&$sHit"
    else
      sEndNew="?$sHit"
    fi
  done
fi
sNewMailto="$sStart$sEndNew"

# Modify as necessary.
$TERMINAL -e "mutt${sNewMailto:+ \"$sNewMailto\"}" &
