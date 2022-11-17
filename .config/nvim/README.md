# Setting up nvim

See https://gist.github.com/gwarf/42a0a13ff2bf32a0e79d347e43831cae

## Install ruby env

```shell
$ rvm install 3.1.2
$ rvm ruby-3.1.2 do rvm gemset create neovim
$ rvm ruby-3.1.2@neovim do gem install neovim
# Updating existing info, if needed
$ echo '3.1.2' > .ruby-version
$ echo 'neovim' > .ruby-gemset
```
