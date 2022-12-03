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
cd ~/repos/dotfiles
# Rebuild all system conf
# Equivalent? to: sudo nixos-rebuild switch --flake .
nix build ".#nixosConfigurations.brutal.config.system.build.toplevel"
sudo result/bin/switch-to-configuration switch
# XXX not working
# nix build ".#nixosConfigurations.brutal.system"
# XXX not needed?
# nixos-rebuild build --flake '.#brutal'
```

## References

https://github.com/gvolpe/nix-config
