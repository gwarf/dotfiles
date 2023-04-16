## TODO
# - keybase
# - nextcloud
# - i3 config: minimal: cpu temp in bar
# - access email (mutt, isync, notmuch)
{ config, pkgs, pkgs-unstable, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Htop
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
  programs.htop.enable = true;
  programs.htop.settings.show_program_path = true;

  home.packages = with pkgs; [
    # https://github.com/malob/nixpkgs/blob/d930a2e7749248a0b0af7d025d667030011fa7b8/home/packages.nix
    # some basics
    curl
    wget

    # Cool stuff
    doggo
    du-dust
    exa
    fd
    fortune
    gh
    gnupg
    inetutils
    mutt
    pydf
    ripgrep
    silver-searcher
    thefuck
    tree
    xz

    # Graphical tools
    # XXX joplin-cli build failing on macOS
    # joplin
    # nodePackages.joplin
    # nodePackages_latest.joplin
    joplin-desktop

    # Dev stuff
    # XXX maybe to be moved to project-specific envs
    actionlint
    ansible-lint
    beautysh
    black
    deno
    gnumake
    isort
    jq
    nodePackages.alex
    nodePackages.markdownlint-cli
    nodePackages.prettier
    # clang
    # llvm
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

    # Useful nix related tools
    # cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    niv # easy dependency management for nix projects
    nodePackages.node2nix
  ] ++ lib.optionals stdenv.isLinux [
    arch-install-scripts
    checkmake
    clang
    dracula-theme
    gparted
    liquidctl
    llvm
    lm_sensors
    nextcloud-client
    nitrokey-app
    # XXX not working
    # nixpkgs-unstable.pynitrokey
    dict
    libreoffice-still
    perl
    perlPackages.PerlTidy
    vlc
    # perl536Packages.PerlTidy
    python3Packages.flake8
    shfmt
    tree-sitter
  ] ++ lib.optionals stdenv.isDarwin [
    coreutils
    gcc
    m-cli # useful macOS CLI commands
    ncurses
  ];
  programs.tealdeer = {
    enable = true;
    settings = {
      display = {
        compact = true;
        use_pager = false;
      };
      updates = {
        auto_update = false;
      };
    };
  };
}

# vim: foldmethod=marker
