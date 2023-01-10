# https://srid.ca/cli/neovim/install
{ pkgs, inputs, pkgs-unstable, ... }:

{
  programs.neovim = {
    enable = true;
    package = pkgs-unstable.neovim-unwrapped;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
  };
}
