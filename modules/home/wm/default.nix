# TODO
# - automatic unlock of gnome-keyring
{ pkgs, ... }:
{
  imports = [
    ./i3.nix
  ];

  # use gnome keyring for secrets
  home.packages = with pkgs; [
    gnome3.gnome-keyring
    gnome.seahorse
    gnome.gnome-keyring
    pinentry-gnome3
    libsecret
  ];

  programs.feh.enable = true;
}
