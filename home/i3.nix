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
      # https://nix-community.github.io/home-manager/options.html#opt-xsession.windowManager.i3.config.colors
      colors = {
        background = "#F8F8F2";
        focused = {
          background = "#6272A4";
          border = "#6272A4";
          childBorder = "#6272A4";
          indicator = "#6272A4";
          text = "#F8F8F2";
        };
        focusedInactive = {
          background = "#44475A";
          border = "#44475A";
          childBorder = "#44475A";
          indicator = "#44475A";
          text = "#F8F8F2";
        };
        unfocused = {
          background = "#282A36";
          border = "#282A36";
          childBorder = "#282A36";
          indicator = "#282A36";
          text = "#BFBFBF";
        };
        urgent = {
          background = "#FF5555";
          border = "#44475A";
          childBorder = "#FF5555";
          indicator = "#FF5555";
          text = "#F8F8F2";
        };
        placeholder = {
          background = "#282A36";
          border = "#282A36";
          childBorder = "#282A36";
          indicator = "#282A36";
          text = "#F8F8F2";
        };
      };
      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+p" = "exec ${pkgs.dmenu}/bin/dmenu_run -nf '#F8F8F2' -nb '#282A36' -sb '#6272A4' -sf '#F8F8F2' -fn 'monospace-10' -p 'dmenu%'";

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
            # names = ["JetBrainsMono Nerd Font"];
            names = ["JetBrainsMono Nerd Font"];
            size = 12.0;
          };
          position = "bottom";
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
     }];
    };
  };

  # https://github.com/greshake/i3status-rust
  programs.i3status-rust = {
   enable = true;
   bars = {
     bottom = {
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
           block = "custom";
           command = "echo Coolant: $(sensors d5next-hid-3-8 | awk '/^Coolant/ {print $3}')";
         }
         {
           block = "temperature";
           collapsed = false;
           chip = "k10temp-pci-00c3";
           interval = 10;
         }
         {
           block = "temperature";
           collapsed = false;
           chip = "d5next-hid-3-8";
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
