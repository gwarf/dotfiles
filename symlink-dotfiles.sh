#!/bin/sh

dotfiles="~/repos/gwarf/dotfiles"

if [ -d "$dotfiles" ]; then
  echo "Symlinking dotfiles from $dotfiles"
else
  echo "$dotfiles does not exist"
  exit 1
fi

link_conf() {
  from="$1"
  to="$2"
  echo "Linking configuration '$from' to '$to'"
  rm -f "$to"
  ln -s "$from" "$to"
}

for configfile in $(ls $dotfiles/.config); do
  link_conf "$dotfiles/.config/$configfile" "$HOME/.config/$configfile"
done

for dotfile in $(ls $dotfiles/.*); do
  [ $dotfile = '.git' ] && next
  link_conf "$dotfiles/$dotfile" "$HOME/$dotfile"
done
