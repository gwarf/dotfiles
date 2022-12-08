{ config, lib, pkgs, ... }:
{
  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    enableScriptingAddition = true;
    config = {
      focus_follows_mouse          = "autoraise";
      mouse_follows_focus          = "off";
      window_placement             = "second_child";
      window_opacity               = "off";
      window_opacity_duration      = "0.0";
      window_border                = "on";
      window_border_placement      = "inset";
      window_border_width          = 2;
      window_border_radius         = 3;
      active_window_border_topmost = "off";
      window_topmost               = "on";
      window_shadow                = "float";
      active_window_border_color   = "0xff5c7e81";
      normal_window_border_color   = "0xff505050";
      insert_window_border_color   = "0xffd75f5f";
      active_window_opacity        = "1.0";
      normal_window_opacity        = "1.0";
      split_ratio                  = "0.50";
      auto_balance                 = "on";
      mouse_modifier               = "fn";
      mouse_action1                = "move";
      mouse_action2                = "resize";
      layout                       = "bsp";
      top_padding                  = 36;
      bottom_padding               = 10;
      left_padding                 = 10;
      right_padding                = 10;
      window_gap                   = 10;
    };

    extraConfig = ''
        # rules
        yabai -m rule --add app='System Preferences' manage=off
        # Any other arbitrary config here
    '';
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
    skhdConfig = ''
      # applications
      alt - return : ${pkgs.kitty}
      # focus window
      cmd - h : ${pkgs.yabai} -m window --focus west
      cmd - j : ${pkgs.yabai} -m window --focus south
      cmd - k : ${pkgs.yabai} -m window --focus north
      cmd - l : ${pkgs.yabai} -m window --focus east
      cmd + shift - h : ${pkgs.yabai} -m window --focus west
      cmd + shift - j : ${pkgs.yabai} -m window --focus south
      cmd + shift - k : ${pkgs.yabai} -m window --focus north
      cmd + shift - l : ${pkgs.yabai} -m window --focus east
      ctrl + shift - h : ${pkgs.yabai} -m window --focus west
      ctrl + shift - j : ${pkgs.yabai} -m window --focus south
      ctrl + shift - k : ${pkgs.yabai} -m window --focus north
      ctrl + shift - l : ${pkgs.yabai} -m window --focus east
      # # workspaces
      # ctrl + alt - j : ${pkgs.yabai} -m space --focus prev
      # ctrl + alt - k : ${pkgs.yabai} -m space --focus next
      # cmd + alt - j : ${pkgs.yabai} -m space --focus prev
      # cmd + alt - k : ${pkgs.yabai} -m space --focus next
      # # send window to space and follow focus
      # ctrl + alt - l : ${pkgs.yabai} -m window --space prev; ${pkgs.yabai} -m space --focus prev
      # ctrl + alt - h : ${pkgs.yabai} -m window --space next; ${pkgs.yabai} -m space --focus next
      # cmd + alt - l : ${pkgs.yabai} -m window --space prev; ${pkgs.yabai} -m space --focus prev
      # cmd + alt - h : ${pkgs.yabai} -m window --space next; ${pkgs.yabai} -m space --focus next
      # # focus window
      # alt - h : ${pkgs.yabai} -m window --focus west
      # alt - l : ${pkgs.yabai} -m window --focus east
      # # focus window in stacked
      # alt - j : if [ "$(${pkgs.yabai} -m query --spaces --space | jq -r '.type')" = "stack" ]; then ${pkgs.yabai} -m window --focus stack.next; else ${pkgs.yabai} -m window --focus south; fi
      # alt - k : if [ "$(${pkgs.yabai} -m query --spaces --space | jq -r '.type')" = "stack" ]; then ${pkgs.yabai} -m window --focus stack.prev; else ${pkgs.yabai} -m window --focus north; fi
      # # swap managed window
      # shift + alt - h : ${pkgs.yabai} -m window --swap west
      # shift + alt - j : ${pkgs.yabai} -m window --swap south
      # shift + alt - k : ${pkgs.yabai} -m window --swap north
      # shift + alt - l : ${pkgs.yabai} -m window --swap east
      # # increase window size
      # shift + alt - a : ${pkgs.yabai} -m window --resize left:-20:0
      # shift + alt - s : ${pkgs.yabai} -m window --resize right:-20:0
      # # toggle layout
      # alt - t : ${pkgs.yabai} -m space --layout bsp
      # alt - d : ${pkgs.yabai} -m space --layout stack
      # # float / unfloat window and center on screen
      # alt - n : ${pkgs.yabai} -m window --toggle float; \
      #           ${pkgs.yabai} -m window --grid 4:4:1:1:2:2
      # # toggle sticky(+float), topmost, picture-in-picture
      # alt - p : ${pkgs.yabai} -m window --toggle sticky; \
      #           ${pkgs.yabai} -m window --toggle topmost; \
      #           ${pkgs.yabai} -m window --toggle pip
      # reload
      # shift + alt - r : brew services restart skhd; brew services restart yabai; brew services restart sketchybar
      # shift + alt - r : brew services restart skhd; brew services restart yabai; brew services restart sketchybar
    '';
  };
}
