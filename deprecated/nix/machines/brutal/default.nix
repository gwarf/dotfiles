
{ pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Include system configuration
      ./configuration.nix
    ];
}
