# https://srid.ca/cli/neovim/install
{ pkgs, inputs, pkgs-unstable, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in

{
  programs.neovim = {
    enable = true;
    # XXX working on darwin
    # package = pkgs-unstable.neovim-unwrapped;
    package = neovim-nightly;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
  };
}
