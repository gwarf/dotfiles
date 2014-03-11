curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
mkdir -p "$HOME/repos/gwarf"
cd $_
git clone git://github.com/gwarf/dotfiles.git
cd dotfiles
./symlink-dotfiles.sh
