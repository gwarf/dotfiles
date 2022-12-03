```shell
# Reaplying conf from /etc/nixos/configuration.nix
sudo nixos-rebuild switch
# Using flake-based conf for a specific system
cd ~/repos/dotfiles
nix build ".#nixosCofngurations.brutal.system"
```
