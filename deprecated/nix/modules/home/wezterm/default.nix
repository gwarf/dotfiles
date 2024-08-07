{ config, lib, pkgs, pkgs-unstable, ... }:
{
  programs.wezterm.enable = true;
  programs.wezterm.package = pkgs-unstable.wezterm;
  programs.wezterm.extraConfig = ''
    return {
      font = wezterm.font_with_fallback({ "JetBrains Mono", "Material Design Icons", "Material Icons", "Noto Color Emoji" }),
      font_size = 16.0,
      -- FIXME: themes not found, only availalbe in most recent wezterm versions,
      -- color_scheme = "Tokyo Night Storm (Gogh)",
      -- color_scheme = "tokyonight_moon",
      -- color_scheme = "tokyonight_storm",
      color_scheme = "Dracula",
      hide_tab_bar_if_only_one_tab = true,
      default_prog = { "${pkgs.fish}/bin/fish", "-l" },
    }
  '';
}
# vim: foldmethod=marker
