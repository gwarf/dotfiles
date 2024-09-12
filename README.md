# gwarf's dotfiles

My messy **dotfiles** for GNU/Linux, FreeBSD and macOS. WIP :)

## Chezmoi

Some files or configuration parts are for GNU/Linux and FreeBSD and
some others are for macOS.

> Managed using [chezmoi](https://www.chezmoi.io).

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