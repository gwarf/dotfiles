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
# Initialising chezmoi repository
chezmoi init git@github.com:gwarf/dotfiles.git
# Checking changes
chezmoi diff
# Applying changes
chezmoi apply
```

### Pulling changes

#### Pulling changes and reviewing them

```shell
# Pull latest changes and preview them
chezmoi git pull -- --autostash --rebase && chezmoi diff
# Applying them
chezmoi apply
```

#### Pulling changes and apply them without review

```shell
# Verbosy pull and apply changes
chezmoi update -v
```

### Pushing changes

> If autocomit is enabled in `~/.config/chezmoi/chezmoi.toml`, changes made
> with `chezmoi edit` are automatically committed and pushed

```shell
# Open repository clone location
chezmoi cd
# Check status
git status
git diff
# Commit all changes
git commit -a
# Push changes
git push
```
