# gwarf's dotfiles

My messy dotfiles for GNU/Linux and macos. WIP of course :)

> **WIP++** This repository is being converted from [yadm](#yadm) to management
> using [nix](#nix) and [home-manager](https://nix-community.github.io/home-manager/).

## Nix

Currently it's mainly a few random notes and pointers to source of inspiration.

This is very early work, some important tasks are pending:

- [ ] Try to understand what I'm doing :)
- [ ] decide what to track (stable, master, unstable...).
- [ ] clean packages sets in inputs.
- [ ] Disable/clean/remove `/etc/nixos/configuration.nix`, finalise switch to flakes.
- [ ] Manage upgrades.
- [ ] Consolidate macOS and NixOS configuration.
- [ ] Test and document bootstrap in clean NixOS.
- [ ] Test and document bootstrap in clean macOS.
- [ ] Look into https://github.com/gvolpe/neovim-flake.
- [ ] Support home-manager conf on non-NisOS GNU/Linux systems.
- [ ] Look into GitHub actions.
- [ ] Clean static config files.

### On NixOS

#### Managing NixOS using flake

Manage NixOS configruation in `~/repo/dotfiles`.

> [home-manager](https://nix-community.github.io/home-manager/) examples are
> available in the
> [test modules](https://github.com/nix-community/home-manager/blob/master/tests/modules/programs).

```shell
# Download flake locally
gh repo clone gwarf/dotfiles
cd ~/repos/dotfiles/
```

```shell
# Rebuild all system conf
# Used to make test, not changing conf available at boot
nix build ".#nixosConfigurations.brutal.config.system.build.toplevel"
sudo result/bin/switch-to-configuration switch
# Build and siwtch to the new conf, updating boot menu
sudo nixos-rebuild switch --flake .
```

#### Managing NixOS "centrally"

> **Obsolete**

Manage conf in `/etc/nixos/configuration.nix`

```shell
# Reaplying conf from /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

### On Darwin

Using `nix-darwin`, initially baesd on the video and gist from @jmatsushita:
- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://youtu.be/KJgN0lnA5mk
- https://discourse.nixos.org/t/simple-workable-config-for-m1-macbook-pro-monterey-12-0-1-with-nix-flakes-nix-darwin-and-home-manager/16834

```shell
# Rebuild all system conf
nix build ".#nixosConfigurations.Baptistes-MBP.system'
# Switch to the new conf
./result/sw/bin/darwin-rebuild switch --flake .
```

### On archlinux

> TODO

### Deleting old generations

```shell
nix-env -p /nix/var/nix/profiles/system --list-generations
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake .
```

### Searching for a package

- https://search.nixos.org/packages

### References

- https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343

#### Home manager

- https://nixos.wiki/wiki/Home_Manager
- https://nix-community.github.io/home-manager/
- https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix

#### Real world flakes from other users

- Conf using unstable, nixos and nix darwin
  - https://github.com/fmoda3/nix-configs/blob/3d640ab43d676a8aad555bcd29527345554252d0/flake.nix#L70
  - https://github.com/vhsconnect/nixos-config/blob/08f47336b280e21fe360567bfd9c663bd5f1844c/flake.nix#L3
  - https://github.com/Thrimbda/charles/blob/08bb883cff19b01c66bbe25c62c06545ccf40a1c/flake.nix
  - https://github.com/ttak0422/ENV/blob/1478ba70e1a3eddd4dab1b65c191cc320e5b6cf1/flake.nix
  - https://github.com/voidcontext/nix-config/blob/695668066e358be43298eab796f16232a09ba24e/flake.nix
  - https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343/3
- https://dpdmancul.gitlab.io/dotfiles/index.html: fully documented
- https://github.com/jules-goose/nixcfg
- https://github.com/booklearner/nixconfig
- https://github.com/malob/nixpkgs
- https://github.com/gvolpe/nix-config: very complete.
  - neovim in a dedicated flake: https://github.com/gvolpe/neovim-flake
- https://github.com/gmarmstrong/dotfiles
- https://github.com/shaunsingh/nix-darwin-dotfiles/blob/main/flake.nix
- https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343
- https://github.com/wvhulle/nixosConfigurations
- https://github.com/ArdanaLabs/ArdanaTenant
- Dracula colorscheme: https://github.com/RichardYan314/dotfiles-nix

## yadm

> **DEPRECATED**

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
