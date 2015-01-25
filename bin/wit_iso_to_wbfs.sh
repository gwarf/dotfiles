#!/bin/sh


if [ $# -ne 1 ]; then
  >&2 printf 'Please give an iso as parameter.\n'
  exit 1
else
  iso="$1"
  if [ ! -r "$iso" ]; then
    >&2 printf "$iso does not exist!\n"
    exit 1
  fi
fi


wit CP --wbfs --prealloc --progress --split "$iso" --dest '%I_%T/%I.%E'
