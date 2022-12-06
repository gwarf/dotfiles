# NixOS

## Managing nixOS "centrally"

Manage conf in /etc/nixos/configuration.nix

```shell
# Reaplying conf from /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

## Managing using flake

Manage conf in ~/repo/dotfiles

```shell
# Using flake-based conf for a specific system
cd ~/repos/dotfiles/.config
# Rebuild all system conf
# Used to make test, not changing conf available at boot
nix build ".#nixosConfigurations.brutal.config.system.build.toplevel"
sudo result/bin/switch-to-configuration switch
# Build and siwtch to the new conf, updating boot menu
sudo nixos-rebuild switch --flake .
```

### On Darwin

```shell
nix build ".#nixosConfigurations.Baptistes-MBP.system'
./result/sw/bin/darwin-rebuild switch --flake .
```

## Deleting old generations

```shell
nix-env -p /nix/var/nix/profiles/system --list-generations
sudo nix-collect-garbage -d
sudo nixos-rebuild switch --flake .
```

## Searching for a package

- https://search.nixos.org/packages

## References

# Very good

- https://dpdmancul.gitlab.io/dotfiles/index.html

### Conf files

- https://github.com/gvolpe/nix-config: very complete.
  - neovim in a dedicated flake: https://github.com/gvolpe/neovim-flake
- https://github.com/shaunsingh/nix-darwin-dotfiles/blob/main/flake.nix
- https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343
- https://github.com/wvhulle/nixosConfigurations
- https://github.com/ArdanaLabs/ArdanaTenant

### Home manager

- https://nixos.wiki/wiki/Home_Manager
- https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
- https://github.com/gmarmstrong/dotfiles

> Debugging: looking at the test modules for home-manager
> https://github.com/nix-community/home-manager/blob/master/tests/modules/programs
