dotfiles
--------

> Repository being converted to management using nix home-manager

## About

My messy dotfiles. WIP of course :)

Managed using https://yadm.io

Some files or configuration parts are for GNU/Linux and some other are for MacOS X.

## Requirements

* git
* [yadm](https://yadm.io/docs/install)

## Using

``` sh
# Bootstrap
yadm clone git@github.com:gwarf/dotfiles.git
yadm status
# Add a file
yadm add .my-conf-file
yadm commit .my-conf-file -m 'add .my-conf-file'
# Push to remote repository
yadm push
```

## Creating altnerate files

See https://yadm.io/docs/alternates.
It's easier to create them directly in the GitHub repository.
