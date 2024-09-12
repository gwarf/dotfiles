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

## Nix (Legacy)

> The nix setup got converted from
> [yadm](https://github.com/TheLocehiliosan/yadm) to using [nix](#nix) and
> [home-manager](https://nix-community.github.io/home-manager/).

### Searching for a Nix package, an option, …

```shell
# Using new "experimental" nix search command
nix search nixpkgs firefox
# If experimental features are not enabled
nix --extra-experimental-features "nix-command flakes" search nixpkgs firefox
# Using legacy slow nix-env
nix-env -qaP firefox
```

It is also possible to use different online services to search in the browser:

- [NixOS Wiki: Searching packages](https://nixos.wiki/wiki/Searching_packages)
- [Home Manager Manual](https://nix-community.github.io/home-manager/)
- [Home Manager Options](https://nix-community.github.io/home-manager/options.html)
- [Home Manager Options Search](https://mipmip.github.io/home-manager-option-search/)
- [Nix packages search](https://search.nixos.org/packages)
- [Nix options seardch](https://search.nixos.org/options)

### Updating nix flakes inputs

To refresh the information about all flakes inputs, it's possible to
use two commands:

- [`nix flake update --commit-lock-file`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-update.html)
  updates **ALL** inputs and commit the changes to the lock file.

> Beware as if you are using some nighlyt or unstable inputs it could break,
> and commit the change, making reverting a bit less easier (but still doable).

- [`nix flake lock`](https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake-lock.html)
  allows to specify one more multiple inputs to update and then you will have
  to manually commit the changes to the lock file.

```shell
# Checking satus of inputs
nix flake info
# Update all flake inputs and commit lock file
nix flake update --commit-lock-file
# Update main inputs
nix flake lock --update-input nixpkgs \
  --update-input nixpkgs-unstable \
  --update-input nixpkgs-darwin-stable \
  --update-input home-manager
# Update neovim inputs
nix flake lock --update-input neovim-nightly-overlay --update-input nix2lua
# Update nix user repository input
nix flake lock --update-input nur
# Update home-manager input
nix flake lock --update-input home-manager
```

### Nix upgrade

- Read release notes for nix, nixos and home-manager
- Update channels definition (replace existing ones, with most recent ones)
- Update channels
- Rebuild the system

### NixOS setup

> NixOS version: using the stable NixOS release, and allowing to explicitly
> select packages from unstable.

#### Managing NixOS using flakes and Mome Manager

Manage NixOS configuration in `~/repo/dotfiles`.

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
# On macOS
nix flake update --commit-lock-file
darwin-rebuild switch --flake .
# In case the hostname changed (like on a VPN), it can be specified like this
./result/sw/bin/darwin-rebuild switch --flake . -p 'darwinConfigurations.Baptistes-MBP.system'
```

##### Updating

The first thing is to update the nix flake inputs, then rebuilding the system
using those inputs.

```shell
# Rebuilding system
sudo nixos-rebuild switch --flake .
# upgrade nixpkgs **only** and rebuild flake-managed system
sudo nixos-rebuild switch --upgrade --update-input nixpkgs \
  --commit-lock-file --flake ~/repos/dotfiles
# On macOS
nix flake update --commit-lock-file
darwin-rebuild switch --flake .
```

##### Cleaning old generations

```shell
# List generations
nix-env -p /nix/var/nix/profiles/system --list-generations
# Delete all generations
nix-env --delete-generations old
# Delete generations older than 14d
nix-env --delete-generations 14d
# Delete specific generations
nix-env --delete-generations 10 11 14
# Collect garbage
sudo nix-collect-garbage -d
```

### macOS AKA Darwin using flakes and Home Manager

Using `nix-darwin`, initially based on the video and gist from @jmatsushita:

- https://gist.github.com/jmatsushita/5c50ef14b4b96cb24ae5268dab613050
- https://youtu.be/KJgN0lnA5mk
- https://discourse.nixos.org/t/simple-workable-config-for-m1-macbook-pro-monterey-12-0-1-with-nix-flakes-nix-darwin-and-home-manager/16834

The flake can be updated as for other nix anf flake-based systems.

```shell
# Rebuild all system conf
nix build ".#darwinConfigurations.Baptistes-MBP.system"
# Switch to the new conf
./result/sw/bin/darwin-rebuild switch --flake .
```

## Managing project-specific env with nix flakes and direnv

### For python

See:

- [NixOS Wiki: Python](https://nixos.wiki/wiki/Python)
- [NixOS Wiki: Packaging Python](https://nixos.wiki/wiki/Packaging/Python)
- [mach-nix](https://github.com/DavHau/mach-nix), to be replaced by [dream2nix](https://github.com/nix-community/dream2nix)

Using a [Nix flake templates for easy dev envs](https://github.com/the-nix-way/dev-templates):

```shell
nix flake init --template github:the-nix-way/dev-templates#python
direnv allow
# Edit flake.nix as needed, adding packages or python packages.
```

Interesting approach to look into:
[reddit post allowing to use requirements.txt](https://www.reddit.com/r/NixOS/comments/q71v0e/comment/hgn4sar/?utm_source=share&utm_medium=web2x&context=3)

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
  - https://discourse.nixos.
