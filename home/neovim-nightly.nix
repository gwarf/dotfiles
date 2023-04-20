# https://srid.ca/cli/neovim/install
{ config, pkgs, inputs, pkgs-unstable, lib, ... }:

let
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.neovim;
in

{
  programs.neovim = {
    enable = true;
    # package = neovim-unwrapped;
    package = pkgs-unstable.neovim-unwrapped;
    # XXX: disabled for now, temporary issues arriving too often
    # package = neovim-nightly;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
  };
  home.packages = with pkgs; [
    luajit
    luajitPackages.luarocks
    # For LuaSnip
    luajitPackages.jsregexp

    # Dev stuff
    # XXX maybe to be moved to project-specific envs
    actionlint
    ansible-lint
    beautysh
    black
    cargo
    deno
    gnumake
    go
    isort
    jq
    nodePackages.alex
    nodePackages.markdownlint-cli
    nodePackages.prettier
    gnumake
    # XXX textlint doesn't foudn the terminology rule
    # pkgs-unstable.nodePackages.textlint
    # pkgs-unstable.nodePackages.textlint-rule-terminology
    nodejs
    # podman
    pylint
    qemu
    stylua

    # LSP servers
    ltex-ls
    nodePackages.yaml-language-server
    pkgs-unstable.ansible-language-server
    pyright
    rnix-lsp
    sumneko-lua-language-server
    # Required for ltex-ls usage in neovim
    jdk11
    nodePackages.bash-language-server
    nodePackages.vim-language-server
    pkgs-unstable.nodePackages.vscode-json-languageserver
    # Not yet in nixpkgs: https://github.com/NixOS/nixpkgs/pull/193682
    nodePackages.write-good
    pkgs-unstable.marksman
  ] ++ lib.optionals stdenv.isLinux [
    checkmake
  ];
}
