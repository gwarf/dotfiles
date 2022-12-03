{ config, lib, pkgs, ... }:

let
  inherit (lib) elem optionalString;
  inherit (config.home.user-info) nixConfigDirectory;
in

{
  # Fish Shell
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.fish.enable
  programs.fish.enable = true;

  # Add Fish plugins
  home.packages = [ pkgs.fishPlugins.done pkgs.sqlite ];

  # Fish configuration ------------------------------------------------------------------------- {{{

  # Aliases
  programs.fish.shellAliases = with pkgs; {
    # Nix related
    drb = "darwin-rebuild build --flake ${nixConfigDirectory}";
    drs = "darwin-rebuild switch --flake ${nixConfigDirectory}";
    flakeup = "nix flake update ${nixConfigDirectory}";
    nb = "nix build";
    nd = "nix develop";
    nf = "nix flake";
    nr = "nix run";
    ns = "nix search";

    # Other
    vim = "nvim";
    vimdiff = "nvim -d";
    ".." = "cd ..";
    ":q" = "exit";
    cat = "${bat}/bin/bat";
    du = "${du-dust}/bin/dust";
    g = "${gitAndTools.git}/bin/git";
    la = "ll -a";
    ll = "ls -l --time-style long-iso --icons";
    ls = "${exa}/bin/exa";
  };

  # Configuration that should be above `loginShellInit` and `interactiveShellInit`.
  programs.fish.shellInit = ''
    set -U fish_term24bit 1
  '';

  programs.fish.interactiveShellInit = ''
    set -g fish_greeting ""
    ${pkgs.thefuck}/bin/thefuck --alias | source

    set -U term_background dark

    # Set color variables
    set emphasized_text  brcyan   # base1
    set normal_text      brblue   # base0
    set secondary_text   brgreen  # base01
    set background_light black    # base02
    set background       brblack  # base03

    set -g fish_color_quote        cyan      # color of commands
    set -g fish_color_redirection  brmagenta # color of IO redirections
    set -g fish_color_end          blue      # color of process separators like ';' and '&'
    set -g fish_color_error        red       # color of potential errors
    set -g fish_color_match        --reverse # color of highlighted matching parenthesis
    set -g fish_color_search_match --background=yellow
    set -g fish_color_selection    --reverse # color of selected text (vi mode)
    set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
    set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
    set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command

    set -g fish_color_command                    $emphasized_text --bold  # color of commands
    set -g fish_color_param                      $normal_text             # color of regular command parameters
    set -g fish_color_comment                    $secondary_text          # color of comments
    set -g fish_color_autosuggestion             $secondary_text          # color of autosuggestions
    set -g fish_pager_color_prefix               $emphasized_text --bold  # color of the pager prefix string
    set -g fish_pager_color_description          $selection_text          # color of the completion description
    set -g fish_pager_color_selected_prefix      $background
    set -g fish_pager_color_selected_completion  $background
    set -g fish_pager_color_selected_description $background

    # Set LS_COLORS
    set -xg LS_COLORS (${pkgs.vivid}/bin/vivid generate solarized-$term_background)

    # Use correct theme for `bat`.
    set -xg BAT_THEME "Solarized (dark)"
  '';
  # }}}
}
# vim: foldmethod=marker
