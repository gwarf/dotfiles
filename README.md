# gwarf's dotfiles

My somewhat messy and ever WIP **dotfiles** for GNU/Linux, FreeBSD and macOS.

> Use at you own risk :)

## Chezmoi

> Everything is managed using [chezmoi](https://www.chezmoi.io).

Some files or configuration parts are only avaible for GNU/Linux, FreeBSD, or
macOS.

OS packages are installed via a [packages.yaml](home/.chezmoidata/packages.yaml)
and using [run_onchange_install-packages.sh](home/run_onchange_install-packages.sh.tmpl).

### Initialising

```shell
chezmoi init gwarf
chezmoi diff
chezmoi apply
```

### Pulling changes

```shell
# Pull changes and review them
chezmoi git pull -- --autostash --rebase && chezmoi diff
# Apply them
chezmoi apply
# Pull and apply all at once
chezmoi update
```

### Pushing changes

```shell
chezmoi cd
git status
git commit -a
git push
```
