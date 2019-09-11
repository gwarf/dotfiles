dotfiles
--------

## About

My messy dotfiles. WIP of course :)

Started to be managed using [dotbot][dotbot], but no mainly managed manually.

Some files or configuration part are Mac OS X specific.

## Requirements

* git

## Bootstrapping

``` sh
URL='https://github.com/gwarf/dotfiles'
git clone "$URL" ~/.dotfiles && cd ~/.dotfiles && ./install
```

In order to push and once GitHub credentials have been confiugred it is
required to update the URL in the ```.git/config``` file:

```
[remote "origin"]
  url = git@github.com:gwarf/dotfiles.git
```

[dotbot]: https://github.com/anishathalye/dotbot/
