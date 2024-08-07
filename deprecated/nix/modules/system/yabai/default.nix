{ config, lib, pkgs, ... }:
let
  keycodes = import ./keycodes.nix;
in
{
  # Interesting configurations
  # https://bryce-s.com/yabai/
  # https://gist.github.com/TomFaulkner/5531bde4f2955c08bcd07d6e308f6d59
  # https://sylvaindurand.org/yabai-tiling-window-manager-for-macos/
  # https://github.com/peel/dotfiles/blob/7c4d9a343b02387bdaa429b6b9e903c85a729a6f/modules/darwin/setup/wm.nix
  # https://github.com/breuerfelix/dotfiles/blob/1197b1cc961588f209ef3ee7fbb0927b49a4b91a/darwin/yabai.nix

  # XXX Yabai works, but not skhd
  services.yabai = {
    enable = false;
    package = pkgs.yabai;
    # Would require disabling security features
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
        # Workspaces management
        yabai -m space 1 --label term
        yabai -m space 2 --label code
        yabai -m space 3 --label www
        yabai -m space 4 --label chat
        yabai -m space 5 --label todo
        yabai -m space 6 --label music
        yabai -m space 7 --label seven
        yabai -m space 8 --label eight
        yabai -m space 9 --label nine
        yabai -m space 10 --label ten
        # rules
        yabai -m rule --add app='^System Preferences$' manage=off
        yabai -m rule --add app="^App Store$" manage=off
        yabai -m rule --add app="^Messages$" manage=off
        yabai -m rule --add app="^Zoom$" manage=off
        # Assign apps to spaces
        yabai -m rule --add app="Kitty" space=term
        yabai -m rule --add app="Microsoft Teams" space=chat
        yabai -m rule --add app="Slack" space=chat
        yabai -m rule --add app="Skype" space=chat
        yabai -m rule --add app="Spotify" space=music
    '';
  };

  # XXX skhd is not getting the modifiers properly
  # XXX test/debug using skhd from homebrew
  # https://www.samundra.com.np/skhd-suddenly-stopped-working-after-upgrade/1738
  services.skhd = {
    enable = false;
    package = pkgs.skhd;
    # Written to /etc/skhdrc
    skhdConfig = let
      # alt is option key, but is used to provide additinal chars
      modMask = "cmd";
      moveMask = "ctrl + cmd";
      myTerminal = "${pkgs.kitty}/bin/kitty";
      myEditor = "emacsclient -a '' -nc";
      myBrowser = "open /Applications/Firefox\ Developer\ Edition.app";
      noop = "/dev/null";
      prefix = "${pkgs.yabai}/bin/yabai -m";
      # prefix = "${pkgs.yabaiM1}/bin/yabai -m";
      fstOrSnd = {fst, snd}: domain: "${prefix} ${domain} --focus ${fst} || ${prefix} ${domain} --focus ${snd}";
      nextOrFirst = fstOrSnd { fst = "next"; snd = "first";};
      prevOrLast = fstOrSnd { fst = "prev"; snd = "last";};
    in ''
      # select
      ${modMask} - j                            : ${prefix} window --focus next || ${prefix} window --focus "$((${prefix} query --spaces --display next || ${prefix} query --spaces --display first) |${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."first-window"')" || ${prefix} display --focus next || ${prefix} display --focus first
      ${modMask} - k                            : ${prefix} window --focus prev || ${prefix} window --focus "$((yabai -m query --spaces --display prev || ${prefix} query --spaces --display last) | ${pkgs.jq}/bin/jq -re '.[] | select(.visible == 1)."last-window"')" || ${prefix} display --focus prev || ${prefix} display --focus last
      # close
      ${modMask} - ${keycodes.Delete}           : ${prefix} window --close && yabai -m window --focus prev
      # fullscreen
      ${modMask} - h                            : ${prefix} window --toggle zoom-fullscreen
      # rotate
      ${modMask} - r                            : ${prefix} window --focus smallest && yabai -m window --warp largest && yabai -m window --focus largest
      # increase region
      ${modMask} - ${keycodes.LeftBracket}      : ${prefix} window --resize left:-20:0
      ${modMask} - ${keycodes.RightBracket}     : ${prefix} window --resize right:-20:0
      # spaces ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      # switch
      ${modMask} + alt - j                      : ${prevOrLast "space"}
      ${modMask} + alt - k                      : ${nextOrFirst "space"}
      # send window
      ${modMask} + ${moveMask} - j              : ${prefix} window --space prev
      ${modMask} + ${moveMask} - k              : ${prefix} window --space next
      # display  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      # focus
      ${modMask} - left                         : ${prevOrLast "display"}
      ${modMask} - right                        : ${nextOrFirst "display"}
      # send window
      ${moveMask} - right                       : ${prefix} window --display prev
      ${moveMask} - left                        : ${prefix} window --display next
      # apps  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ${modMask} - return                       : ${myTerminal}
      ${modMask} + shift - return               : ${myEditor}
      ${modMask} - b                            : ${myBrowser}
      # reset  ▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁▁
      ${modMask} - q                            : pkill yabai; pkill skhd; osascript -e 'display notification "wm restarted"'
    '';
  };
}
