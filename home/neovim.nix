# https://srid.ca/cli/neovim/install
{  pkgs, inputs, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in
{
  programs.neovim = {
    enable = true;
    package = neovim-nightly;

    extraPackages = [
    ];

    plugins = with pkgs.vimPlugins; [
      vim-airline
      papercolor-theme
    ];

    extraConfig = ''
      set background=dark
      colorscheme PaperColor
    '';
  };
}
