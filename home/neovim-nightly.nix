# https://srid.ca/cli/neovim/install
{ pkgs, inputs, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in
{
  programs.neovim = {
    enable = true;
    package = neovim-nightly;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
  };
}
