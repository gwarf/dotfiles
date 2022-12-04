{ config, lib, pkgs, ... }:

{
  # programs.i3status-rust.enable = true;
  programs.i3status-rust = {
   enable = true;
   bars = {
     bottom = {
       # theme = (import ../gruvbox.nix).i3status-rust;
       # icons = "awesome5";
       blocks = [
         {block = "cpu";}
         {block = "memory";}
         {block = "disk_space";}
         #{ block = "nvidia_gpu"; }

         #{ block = "docker"; }

         {block = "net";}
         {
           block = "networkmanager";
           device_format = "{icon}{ap}";
         }

         {
           block = "time";
           format = "%F %a %R";
         }
         # {
         #   block = "keyboard_layout";
         #   driver = "sway";
         #   mappings = {
         #     "English (US)" = "EN";
         #     # "Hebrew (N/A)" = "HE";
         #   };
         # }
         # {block = "sound";}
         {
           block = "battery";
           hide_missing = true;
         }
       ];
     };
   };
  };
  xsession.windowManager.i3.config.bars = [
    {
      status_command = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";
    }
  ];
}
