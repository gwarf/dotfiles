# gwarf's dotfiles

My messy **dotfiles** for GNU/Linux and macos. WIP of course :)

Some files or configuration parts are for GNU/Linux (Archlinux and NixOS) and
some others are for macOS.

> **WIP++** I'm currently converting this repository from [yadm](#yadm) to
> management using [nix](#nix) and
> [home-manager](https://nix-community.github.io/home-manager/).

## Nix

Currently, it's mainly a few random notes and pointers to source of inspiration.

This is very early work, some important tasks are pending:

- [ ] Try to understand what I'm doing :)
- [ ] Read [Practical Nix Flakes](https://serokell.io/blog/practical-nix-flakes)
- [ ] Finalise mail configuration
- [ ] Import zsh configuration
- [ ] Finalise fish configuration
- [ ] Finalise neovim configuration
- [ ] Finalise neomutt/mutt configuration
- [ ] Unlock gnome keyring on login
- [ ] Check https://nixos.org/guides/nix-pills/
- [ ] Read
      https://www.reddit.com/r/NixOS/comments/xtq2tb/best_way_to_manage_multiple_home_manager_configs/
- [-] Decide what to track (stable, master, unstable...) or
  [mix](https://github.com/nix-community/home-manager/issues/1538).
- [ ] Clean packages sets in inputs.
- [ ] Disable/clean/remove `/etc/nixos/configuration.nix`, finalise switch to
      flakes. Unless it makes sense to keep this to do system conf?
- [ ] Manage upgrades.
- [ ] Consolidate macOS and NixOS configuration.
- [ ] Look into https://github.com/gvolpe/neovim-flake.
- [ ] Support home-manager conf on non-NisOS GNU/Linux systems.
- [ ] Test and document bootstrap in clean NixOS.
- [ ] Test and document bootstrap in clean macOS.
- [ ] Look into GitHub actions.
- [ ] Clean static config files.

### NixOS setup

> NixOS version: using the stable NixOS release, and allowing to explicitely
> select packages from unstable.

#### Managing NixOS using flakes and Mome Manager

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

##### Updating

```shell
# Checking satus of inputs
nix flake info
# Update all flake inputs and commit lock file
nix flake update --commit-lock-file
# Only update home-manager input
nix flake lock --update-input home-manager
# Rebuild system
sudo nixos-rebuild switch --flake .
# upgrade nixpkgs and rebuild system
sudo nixos-rebuild switch --upgrade --update-input nixpkgs --commit-lock-file --flake /home/baptiste/repos/dotfiles
```

##### Cleaning old generations

```shell
# Delete all generations
nix-env --delete-generations old
# Delete generations older than 14d
nix-env --delete-generations 14d
# Delete specific generations
nix-env --delete-generations 10 11 14
```

#### Managing NixOS "centrally"

> **Obsolete**

Manage conf in `/etc/nixos/configuration.nix`

```shell
# Reaplying conf from /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

### macOS AKA Darwin using flakes and Home Manager

Using `nix-darwin`, initially baesd on the video and gist from @jmatsushita:

- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://youtu.be/KJgN0lnA5mk
- https://discourse.nixos.org/t/simple-workable-config-for-m1-macbook-pro-monterey-12-0-1-with-nix-flakes-nix-darwin-and-home-manager/16834

```shell
# Rebuild all system conf
nix build ".#darwinConfigurations.Baptistes-MBP.system"
# Switch to the new conf
./result/sw/bin/darwin-rebuild switch --flake .
```

### On Archlinux using Home Manager

> TODO

### Searching for a Nix package, an option,...

```shell
# Using new "experimental" nix search command
nix search nixpkgs firefox
# If experimental features are not enabled
nix --extra-experimental-features "nix-command flakes" search nixpkgs firefox
# Using legacy slow nix-env
nix-env -qaP firefox
```

It is also possible to use different online services to easily search.

- [NixOS Wiki: Searching packages](https://nixos.wiki/wiki/Searching_packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Home Manager Options Search](https://mipmip.github.io/home-manager-option-search/)
- [Nix packages search](https://search.nixos.org/packages)
- [Nix options seardch](https://search.nixos.org/options)

### Deleting old generations

```shell
nix-env -p /nix/var/nix/profiles/system --list-generations
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake .
```

### References

#### Videos

- https://youtu.be/AGVXJ-TIv3Y

#### Flakes

- [Practical Nix Flakes](https://serokell.io/blog/practical-nix-flakes)
- https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343

#### Nix Darwin

- [Declarative macOS Configuration Using nix-darwin And home-manager](https://xyno.space/post/nix-darwin-introduction)

#### Home manager

- https://nixos.wiki/wiki/Home_Manager
- https://nix-community.github.io/home-manager/
- https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix

#### Real world flakes from other users

- Conf using unstable, nixos and nix darwin
  - https://github.com/MatthiasBenaets/nixos-config
  - https://github.com/water-sucks/nixed/blob/main/home/profiles/apps/kitty/default.nix
  - https://github.com/Baitinq/nixos-config
  - https://github.com/jonringer/nixpkgs-config
  - https://github.com/fmoda3/nix-configs/blob/3d640ab43d676a8aad555bcd29527345554252d0/flake.nix#L70
  - https://github.com/vhsconnect/nixos-config/blob/08f47336b280e21fe360567bfd9c663bd5f1844c/flake.nix#L3
  - https://github.com/Thrimbda/charles/blob/08bb883cff19b01c66bbe25c62c06545ccf40a1c/flake.nix
  - https://github.com/ttak0422/ENV/blob/1478ba70e1a3eddd4dab1b65c191cc320e5b6cf1/flake.nix
  - https://github.com/voidcontext/nix-config/blob/695668066e358be43298eab796f16232a09ba24e/flake.nix
  - https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343/3
- [mystrio NixOS configuration](https://sr.ht/~misterio/nix-config/)
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
- https://github.com/Misterio77/nix-starter-configs
- [NisOS on WSL](https://github.com/nix-community/NixOS-WSL)
- [NixOS on SoYouStart](https://web.archive.org/web/20160829180041/http://aborsu.github.io/2015/09/26/Install%20NixOS%20on%20So%20You%20Start%20dedicated%20server/)
- [Installing NixOS on OVH dedicated servers](https://web.archive.org/web/20210125195352/https://www.srid.ca/137ae172.html)
- https://discourse.nixos.org/t/howto-install-nixos-on-an-ovh-dedicated-server/3089/14

## yadm

> **DEPRECATED**

Managed using https://yadm.io

## Requirements

- git
- [yadm](https://yadm.io/docs/install)

## Using

```sh
# Bootstrap
yadm clone git@github.com:gwarf/dotfiles.git
yadm status
# Add a file
yadm add .my-conf-file
yadm commit .my-conf-file -m 'add .my-conf-file'
# Push to remote repository
yadm push
```

## Creating alternate files

See https://yadm.io/docs/alternates. It's easier to create them directly in the
GitHub repository.
