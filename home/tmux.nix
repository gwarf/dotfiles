{ config, pkgs, lib, ... }:

let
  # inherit (config.home.user-info) nixConfigDirectory;

  plugins  = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix {};
  # Not working, impure...
  # tmuxConf = builtins.readFile "${nixConfigDirectory}/configs/tmux/default.conf";
  tmuxConf = builtins.readFile ./default.conf;
in
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    extraConfig = tmuxConf;
    escapeTime = 0;
    keyMode = "vi";
    plugins = with plugins; [
      cpu
      nord # theme
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
    shortcut = "a";
    terminal = "screen-256color";
  };
}

