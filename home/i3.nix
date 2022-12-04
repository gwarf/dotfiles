{ config, lib, pkgs, ... }:

let
  mod = "Mod1";
in {
  # https://github.com/srid/nix-config/blob/705a70c094da53aa50cf560179b973529617eb31/nix/home/i3.nix#L11
  xsession.windowManager.i3 = {
    enable = true;
    config = {
      modifier = mod;
      fonts = {
        names = ["JetBrainsMono Nerd Font"];
        size = 12.0;
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run";

        # Focus
        "${mod}+h" = "focus left";
        "${mod}+j" = "focus down";
        "${mod}+k" = "focus up";
        "${mod}+l" = "focus right";

        # Move
        "${mod}+Shift+h" = "move left";
        "${mod}+Shift+j" = "move down";
        "${mod}+Shift+k" = "move up";
        "${mod}+Shift+l" = "move right";
      };
      bars = [{
          fonts = {
            names = ["JetBrainsMono Nerd Font"];
            size = 12.0;
          };
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
     }];
    };
  };

  programs.i3status-rust = {
   enable = true;
   bars = {
     bottom = {
       # https://github.com/greshake/i3status-rust/blob/master/doc/themes.md#available-themes
       # theme = "nord-dark";
       theme = "dracula";
       icons = "awesome5";
       blocks = [
         # XXX add a custom block for liquidctl
         {
           block = "custom";
           command = "$(uname) $(uname -r)";
           interval = "once";
         }
         {block = "cpu";}
         {
           block = "custom";
           command = "echo CPU: $(sensors k10temp-pci-00c3 | awk '/^Tdie/ {print $2}')";
         }
         {
           block = "temperature";
           collapsed = false;
           # chip = "k10temp-pci-00c3";
           interval = 10;
         }
         {block = "memory";}
         {
           block = "disk_space";
           format = "{icon} {used}/{total} ({available} free)";
         }
         {block = "load";}
         {block = "net";}
         {
           block = "networkmanager";
           device_format = "{icon}{ap}{ips}";
           on_click = "${pkgs.kitty}/bin/kitty -e nmtui";
         }
         {
           block = "time";
           format = "%F %A %R";
           timezone = "Europe/Paris";
           locale = "fr_FR";
         }
       ];
     };
   };
  };
}
