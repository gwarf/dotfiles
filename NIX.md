# NixOS

## Managing nixOS "centrally"

Manage conf in /etc/nixos/configuration.nix

```shell
# Reaplying conf from /etc/nixos/configuration.nix
sudo nixos-rebuild switch
```

## Managing using flake

```shell
# Using flake-based conf for a specific system
cd ~/repos/dotfiles/.config
# Rebuild all system conf
# Equivalent? to: sudo nixos-rebuild switch --flake .
nix build ".#nixosConfigurations.brutal.config.system.build.toplevel"
sudo result/bin/switch-to-configuration switch
# XXX not working
# nix build ".#nixosConfigurations.brutal.system"
# XXX not needed?
# nixos-rebuild build --flake '.#brutal'
home-manager switch
```

## References

### Conf files

https://github.com/gvolpe/nix-config
https://github.com/shaunsingh/nix-darwin-dotfiles/blob/main/flake.nix
https://discourse.nixos.org/t/system-config-flake-with-darwin-and-linux-system-definitions/22343

### Home manager

https://nixos.wiki/wiki/Home_Manager
https://ghedam.at/24353/tutorial-getting-started-with-home-manager-for-nix
