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
    # XXX: nightly version disabled for now, temporary issues arriving too often
    # package = neovim-nightly;

    # use nvim by default
    vimAlias = true;
    vimdiffAlias = true;
    viAlias = true;
    # XXX: only for nixos, for https://github.com/kkharji/sqlite.lua
    # FIXME: breaking using non managed lazyvim setup
    # plugins = [
    #   {
    #     plugin = pkgs.vimPlugins.sqlite-lua;
    #     config = "let g:sqlite_clib_path = '${pkgs.sqlite.out}/lib/libsqlite3.so'";
    #   }
    # ];
  };
  home.packages = with pkgs; [
    luajit
    luajitPackages.luarocks
    # XXX: trying to address issues with checkhealth
    # lua51Packages.luarocks
    # For LuaSnip
    luajitPackages.jsregexp

    tree-sitter

    # Dev stuff
    # XXX maybe to be moved to project-specific envs
    actionlint
    ansible-lint
    beautysh
    black
    cargo
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
    # building treesitter stuff in nvim
    gcc
    # yanky sqlite support in nvim
    sqlite

    # LSP servers that are installed globally
    nodePackages.yaml-language-server
    pkgs-unstable.ansible-language-server
    pyright
    nil
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
