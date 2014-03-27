#!/bin/sh

i3status | while :
do
  read line
  playing="$(ncmpcpp -c ~/.ncmpcpp/config --now-playing)"
  echo "$playing | $line" || exit 1
done
