# Setting up nvim

See https://gist.github.com/gwarf/42a0a13ff2bf32a0e79d347e43831cae

## Install python env

```shell
$ cd ~/.config/nvim
$ pyenv install --list
$ pyenv install 3.10.8
$ cd ~/.config/nvim
$ pyenv local 3.10.8
$ mkdir -p ~/.virtualenvs
$ python -m venv ~/.virtualenvs/neovim3
$ source ~/.virtualenvs/neovim3/bin/activate
$ pip install -r requirements.txt
```

## Install ruby env

```shell
$ cd ~/.config/nvim
$ rvm install 3.1.2
$ rvm ruby-3.1.2 do rvm gemset create neovim
$ rvm ruby-3.1.2@neovim do gem install neovim
# Updating existing info, if needed
$ echo '3.1.2' > .ruby-version
$ echo 'neovim' > .ruby-gemset
```
