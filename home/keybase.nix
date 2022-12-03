{ config, lib, pkgs, ... }:

{
  # Keybase secure messaging
  # https://keybase.io/
  services.keybase.enable = true;
  services.kbfs.enable = true;
  # services.kbfs.enableRedirector = true;
  home.packages = with pkgs; [
    keybase-gui
  ];
}

