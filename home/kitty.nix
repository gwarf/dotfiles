{ config, lib, pkgs, colorscheme, ... }:

{
  # For colors
  # imports = [
  #   nix-colors.homeManagerModule
  # ];

  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty.enable = true;

  # Colors config ------------------------------------------------------------------------------ {{{
  # colorScheme = nix-colors.colorSchemes.dracula;
  # }}}

  # General config ----------------------------------------------------------------------------- {{{
  programs.kitty.settings = {
    font_family = "Cascadia Code PL";
    font_size = "14.0";
    adjust_line_height = "140%";
    disable_ligatures = "cursor"; # disable ligatures when cursor is on them

    # Window layout
    hide_window_decorations = "titlebar-only";
    window_padding_width = "10";

    # Tab bar
    tab_bar_edge = "top";
    tab_bar_style = "powerline";
    tab_title_template = "Tab {index}: {title}";
    active_tab_font_style = "bold";
    inactive_tab_font_style = "normal";
    tab_activity_symbol = "";

    # Colors
    # foreground = "#${config.colorScheme.colors.base05}";
    # background = "#${config.colorScheme.colors.base00}";
    foreground = "${colorscheme.fg-primary}";
    background = "${colorscheme.bg-primary}";
    color0 = "${colorscheme.black}";
    color1 = "${colorscheme.red}";
    color2 = "${colorscheme.green}";
    color3 = "${colorscheme.yellow}";
    color4 = "${colorscheme.blue}";
    color5 = "${colorscheme.magenta}";
    color6 = "${colorscheme.cyan}";
    color7 = "${colorscheme.white}";
    color8 = "${colorscheme.bright-black}";
    color9 = "${colorscheme.bright-red}";
    color10 = "${colorscheme.bright-green}";
    color11 = "${colorscheme.bright-yellow}";
    color12 = "${colorscheme.bright-blue}";
    color13 = "${colorscheme.bright-magenta}";
    color14 = "${colorscheme.bright-cyan}";
    color15 = "${colorscheme.bright-white}";
  };

  # Change the style of italic font variants
  programs.kitty.extraConfig = ''
    modify_font underline_thickness 400%
    modify_font underline_position 2
  '';

  programs.kitty.extras.useSymbolsFromNerdFont = "JetBrainsMono Nerd Font";
  # }}}

}
# vim: foldmethod=marker
