# https://github.com/gvolpe/nix-config/blob/1c5ef00d2ecec075c4b7f78cddcde3598dd0c7a0/home/programs/tmux/default.nix
{ config, pkgs, lib, ... }:

{
  # XXX open pane in same dir
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    escapeTime = 0;
    keyMode = "vi";
    # shell = "${pkgs.fish}/bin/fish";
    plugins = with pkgs.tmuxPlugins; [
      cpu
      yank
      pain-control
      copycat
      open
      prefix-highlight
      # sessionist
      sensible
      logging
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-show-fahrenheit false
          set -g @dracula-show-powerline true
          set -g @dracula-show-left-icon 💀
          set -g @dracula-show-left-sep 
          set -g @dracula-show-right-sep 
          # set -g @dracula-border-contrast true
        '';
      }
    ];
    # XXX: required to get italics: tmux-256color or xterm-kitty
    # tmux-256color not working fine with delta
    # terminal = "xterm-kitty";
    terminal = "tmux-256color";
    extraConfig = ''
      # Allow nested tmux sessions by making "C-b b" possible for sending a control
      # sequence to a nested session
      bind-key b send-prefix

      # Use fish as shell
      set -g default-command ${pkgs.fish}/bin/fish
      set -g default-shell ${pkgs.fish}/bin/fish

      # automatically renumber tmux windows
      set -g renumber-windows on

      # Disable automatic changes of titles
      set -g set-titles on
      set-window-option -g automatic-rename on
      set-window-option -g allow-rename on

      # status bar at the top of the screen
      set-option -g status-position "top"

      # Activity Monitoring
      setw -g monitor-activity off
      set -g visual-activity off

      # option for terminal colors
      set -sa terminal-features ",xterm-kitty:RGB"

      ############ Key Bindings ############

      # reload config file
      bind r source-file ~/.tmux.conf \; display "Config Reloaded!"

      # split window and fix path for tmux 1.9
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # synchronize all panes in a window
      bind y setw synchronize-panes

      # pane movement shortcuts
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      # Resize pane shortcuts
      bind -r H resize-pane -L 10
      bind -r J resize-pane -D 10
      bind -r K resize-pane -U 10
      bind -r L resize-pane -R 10

      # Remap x to avoid confirmation to kill pane
      bind-key x kill-pane

      # Move windows
      bind-key S-Left swap-window -t -1\; select-window -t -1
      bind-key S-Right swap-window -t +1\; select-window -t +1

      # Window movement / renumbering like in screen's :number
      bind-key m command-prompt -p "move window to:"  "swap-window -t '%%'"
      bind-key . command-prompt "move-window -r -t '%%'"

      # Send pane next to another one
      bind-key s command-prompt -p "send pane to:"  "join-pane -t '%%'"

      # For yazi
      # https://github.com/sxyazi/yazi/wiki/Image-preview-within-tmux
      # FIXME: not working with kitty in tmux
      set -g allow-passthrough on
      # set -ga update-environment TERM
      # set -ga update-environment TERM_PROGRAM
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM
    '';
  };
}
