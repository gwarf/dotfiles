{ config, lib, pkgs, ... }:

let
  mod = "Mod1";
in
{
  # https://github.com/srid/nix-config/blob/705a70c094da53aa50cf560179b973529617eb31/nix/home/i3.nix#L11
  # https://nix-community.github.io/home-manager/options.html#opt-xsession.windowManager.i3.config
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;
    config = {
      # XXX gaps got merged to main igaps, to be released in 4.22
      # gaps = {
      #   bottom = 5;
      #   horizontal = 5;
      #   left = 5;
      #   right = 5;
      #   inner = 12;
      #   outer = 5;
      #   top = 5;
      #   vertical = 5;
      #   smartBorders = "on";
      #   smartGaps = true;
      # };
      window.titlebar = false;
      fonts = {
        names = [ "JetBrainsMono Nerd Font" ];
        size = 12.0;
      };
      # press two times the same workspace change to go back
      workspaceAutoBackAndForth = true;
      modifier = mod;
      keybindings = lib.mkOptionDefault {
        "${mod}+Return" = "exec ${pkgs.kitty}/bin/kitty";
        "${mod}+p" = "exec \"${pkgs.rofi}/bin/rofi -show combi -combi-modes window,run,ssh -modes combi -show-icons -font 'Awesome 5' -theme arthur\"";

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
      defaultWorkspace = "1";
      floating.criteria = [
        { title = "Steam - Update News"; }
        { class = "Pavucontrol"; }
      ];
      assigns = {
        "1" = [{ class = "^kitty$"; }];
        "2" = [{ class = "^firefox$"; }];
        "3" = [{ class = "^Keybase$"; }];
        "4" = [{ class = "^Joplin$"; }];
      };
      startup = [
        {
          command = "feh --no-fehbg --bg-fill ~/repos/dotfiles/.config/herbstluftwm/fantasy-landscape2.jpg";
          notification = false;
          always = true;
        }
        { command = "dunst"; notification = false; }
        { command = "kitty"; }
        # XXX to be re-enabled once properly setup
        # { command = "nextcloud --background"; notification = false; }
        # { command = "firefox"; }
        # { command = "joplin-desktop"; }
        # { command = "keybase-gui";  }
      ];
      # https://github.com/dracula/i3/blob/master/.config/i3/config
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
      bars = [{
        colors = {
          background = "#282A36";
          statusline = "#F8F8F2";
          separator = "#44475A";
          focusedWorkspace = {
            background = "#44475A";
            border = "#44475A";
            text = "#F8F8F2";
          };
          activeWorkspace = {
            background = "#44475A";
            border = "#282A36";
            text = "#F8F8F2";
          };
          inactiveWorkspace = {
            background = "#282A36";
            border = "#282A36";
            text = "#BFBFBF";
          };
          urgentWorkspace = {
            background = "#FF5555";
            border = "#FF5555";
            text = "#F8F8F2";
          };
          bindingMode = {
            background = "#FF5555";
            border = "#FF5555";
            text = "#F8F8F2";
          };
        };
        fonts = {
          names = [ "JetBrainsMono Nerd Font" ];
          size = 12.0;
        };
        position = "bottom";
        statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-bottom.toml";
      }];
    };
    extraConfig = ''
      # FIXME workspace naming does not work
      # set $ws1 "1: term"
      # set $ws2 "2: web"
      # set $ws3 "3: chat"
      # set $ws4 "4: notes"
      # set $ws5 "5: media"
      # set $ws6 "6: vm"
      # set $ws7 "7: misc"
      # bindsym Mod1+1 workspace number $ws1
      # bindsym Mod1+2 workspace number $ws2
      # bindsym Mod1+3 workspace number $ws3
      # bindsym Mod1+4 workspace number $ws4
      # bindsym Mod1+5 workspace number $ws5
      # bindsym Mod1+6 workspace number $ws6
      # bindsym Mod1+7 workspace number $ws7
      # bindsym Mod1+Shift+1 move container to workspace number $ws1
      # bindsym Mod1+Shift+2 move container to workspace number $ws2
      # bindsym Mod1+Shift+3 move container to workspace number $ws3
      # bindsym Mod1+Shift+4 move container to workspace number $ws4
      # bindsym Mod1+Shift+5 move container to workspace number $ws5
      # bindsym Mod1+Shift+6 move container to workspace number $ws6
      # bindsym Mod1+Shift+7 move container to workspace number $ws7
    '';
  };

  # https://github.com/greshake/i3status-rust
  programs.i3status-rust = {
    enable = true;
    bars = {
      bottom = {
        theme = "dracula";
        icons = "awesome5";
        blocks = [
          {
            block = "custom";
            command = "echo $(uname) $(uname -r)";
            interval = "once";
          }
          {
            block = "temperature";
            #collapsed = false;
            chip = "k10temp-pci-00c3";
            # format = "CPU: {average} avg, {max} max";
            interval = 10;
          }
          {
            block = "custom";
            command = "echo $(liquidctl --match 'D5 Next' status | grep -e speed -e temp | awk '{printf \"%s \", substr($0, 28,4)}' | awk '{printf \" %s %s\", substr($0,0,4), substr($0,5,5)}')";
            interval = 5;
          }
          { block = "memory"; }
          {
            block = "disk_space";
            # format = "\${icon} \${used}/\${total} (\${available} free)";
          }
          { block = "load"; }
          { block = "cpu"; }
          { block = "net"; }
          # {
          #   block = "networkmanager";
          #   device_format = "{icon}{ap}{ips}";
          #   on_click = "${pkgs.kitty}/bin/kitty -e nmtui";
          # }
          {
            block = "time";
            # format = "%F %A %R";
            timezone = "Europe/Paris";
            # locale = "fr_FR";
          }
        ];
      };
    };
  };

  # Install rofi launcher
  home.packages = with pkgs; [
    rofi
    # rofi-pass
    rofi-rbw
    pinentry-rofi
    dunst
  ];

  services.dunst.enable = true;
}
