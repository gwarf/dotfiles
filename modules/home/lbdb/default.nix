{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    lbdb
  ];
  home.file.".lbdbrc".source = ./lbdbrc;
}

# vim: foldmethod=marker
