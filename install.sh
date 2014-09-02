#!/bin/sh

#echo 'Installing Oh-my-zsh.'
#curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

echo 'Installing prezto.'
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

echo 'Installing vim conf.'
curl -L https://raw.github.com/gwarf/vim/master/install.sh | sh

echo 'Cloning dotfiles'
mkdir -p "$HOME/repos/gwarf"
cd $_
git clone git://github.com/gwarf/dotfiles.git

echo 'Symlink-ing dotfiles'
cd dotfiles
./symlink-dotfiles.sh
