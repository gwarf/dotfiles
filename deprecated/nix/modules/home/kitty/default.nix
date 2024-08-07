{ config, lib, pkgs, pkgs-unstable, ... }:

{
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://nix-community.github.io/home-manager/options.xhtml#opt-programs.kitty.enable
  programs.kitty.enable = true;
  programs.kitty.package = pkgs-unstable.kitty;

  # Use a static configuration file for colors
  home.file.".config/kitty/tokyonight_storm.conf".source = ./tokyonight_storm.conf;
  home.file.".config/kitty/tokyonight_moon.conf".source = ./tokyonight_moon.conf;
  home.file.".config/kitty/dracula.conf".source = ./dracula.conf;

  # General config
  # https://sw.kovidgoyal.net/kitty/conf/
  programs.kitty.settings = {
    font_family = "JetBrainsMono";
    # font_family = "Cascadia Code PL";
    # font_family = "Menlo";
    font_size = "16.0";
    adjust_line_height = "140%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    # hide_window_decorations = "titlebar-only";
    hide_window_decorations = "no";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_title_template = "Tab {index}: {title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "";
    # Use fish as shell
    shell = "${pkgs.fish}/bin/fish --interactive --login";
  };

  programs.kitty.extraConfig = ''
    # Load theme
    include tokyonight_storm.conf
    # include tokyonight_moon.conf
    # include dracula.conf

    # Change the style of italic font variants
    modify_font underline_thickness 400%
    modify_font underline_position 2

    # https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
    # XXX: 34:= is not a unicode codepoint of the form U+number in line
    # symbol_map = "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D JetBrainsMono Nerd Font";
    # symbol_map = "U+E5FA-U+E62B,U+E700-U+E7C5,U+F000-U+F2E0,U+E200-U+E2A9,U+F500-U+FD46,U+E300-U+E3EB,U+F400-U+F4A8,U+2665,U+26a1,U+F27C,U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D2,U+E0D4,U+23FB-U+23FE,U+2B58,U+F300-U+F313,U+E000-U+E00D Menlo";
  '';
}

# vim: foldmethod=marker
