{ config, pkgs, lib, ... }:

{
  home.stateVersion = "22.11";

  # https://github.com/malob/nixpkgs/blob/master/home/default.nix

  # Direnv, load and unload environment variables depending on the current directory.
  # https://direnv.net
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.direnv.enable
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  home.packages = with pkgs; [
    # Some basics
    coreutils
    curl
    wget
    # neovim
    # gnupg
    # mutt
    # fortune
    # gh
    # firefox
    # kitty

    # Dev stuff
    # (agda.withPackages (p: [ p.standard-library ]))
    # google-cloud-sdk
    # haskellPackages.cabal-install
    # haskellPackages.hoogle
    # haskellPackages.hpack
    # haskellPackages.implicit-hie
    # haskellPackages.stack
    # idris2
    jq
    # nodePackages.typescript
    # nodejs
    # purescript

    # Useful nix related tools
    # cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    niv # easy dependency management for nix projects
    nodePackages.node2nix

  ] ++ lib.optionals stdenv.isDarwin [
    cocoapods
    m-cli # useful macOS CLI commands
  ];
}
