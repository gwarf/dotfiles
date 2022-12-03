
{ config, lib, pkgs, ... }:

{
  programs.firefox.policies = {
    extensionsSettings = {
      "*" = {
        "installation_mode" = "blocked";
        "allowed_types" = ["extension"];
      };
      "uBlock0@raymondhill.net" = {
      installation_mode = "force_installed";
      };
    };
  };
  programs.firefox = {
    enable = true;
    preferences = {
    };
    package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
      extraPolicies = {
        ExtensionSettings = let
          ext = name: {
            installation_mode = "force_installed";
            install_url = "https://addons.mozilla.org/firefox/downloads/latest/${name}/latest.xpi";
          };
        in {
          "*" = {
            installation_mode = "blocked";
            blocked_install_message = "Extensions managed by home-manager.";
          };
          "uBlock0@raymondhill.net" = ext "ublock-origin";
        };
      #  <<<modules/home/fiefox-policies>>>
      };
    };
  };
}
