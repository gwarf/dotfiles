{ config, lib, pkgs, ... }:

{
  # Kitty terminal
  # https://sw.kovidgoyal.net/kitty/conf.html
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.kitty.enable
  programs.kitty.enable = true;

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

    # Dracula Colors {{{
    foreground = "#f8f8f2";
    background = "#282a36";
    selection_foreground = "#ffffff";
    selection_background = "#44475a";
    # black
    color0 = "#21222c";
    color8 = "#6272a4";
    # red
    color1 = "#ff5555";
    color9 = "#ff6e6e";
    # green
    color2 = "#50fa7b";
    color10 = "#69ff94";
    # yellow
    color3 = "#f1fa8c";
    color11 = "#ffffa5";
    # blue
    color4 = "#bd93f9";
    color12 = "#d6acff";
    # magenta
    color5 = "#ff79c6";
    color13 = "#ff92df";
    # cyan
    color6 = "#8be9fd";
    color14 = "#a4ffff";
    # white
    color7 = "#f8f8f2";
    color15 = "#ffffff";
    # Cursor colors
    cursor = "#f8f8f2";
    cursor_text_color = "background";
    # Tab bar colors
    active_tab_foreground = "#282a36";
    active_tab_background = "#f8f8f2";
    inactive_tab_foreground = "#282a36";
    inactive_tab_background = "#6272a4";
    # Marks
    mark1_foreground = "#282a36";
    mark1_background = "#ff5555";
    # Splits/Windows
    active_border_color = "#f8f8f2";
    inactive_border_color = "#6272a4";
    # }}}
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
