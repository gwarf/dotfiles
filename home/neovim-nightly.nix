# https://srid.ca/cli/neovim/install
{ pkgs, inputs, pkgs-unstable, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in

{
  programs.neovim = {
    enable = true;
    # package = neovim-unwrapped;
    package = pkgs-unstable.neovim-unwrapped;
    # XXX: disabled until most plugins are updated to work with neovim 0.10
    # package = neovim-nightly;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
  };
}
