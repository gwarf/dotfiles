dotfiles
--------

## About

My messy dotfiles. WIP of course :)

Managed using [dotbot][dotbot].

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
