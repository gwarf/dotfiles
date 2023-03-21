## TODO
# - keybase
# - nextcloud
# - i3 config: minimal: cpu temp in bar
# - access email (mutt, isync, notmuch)
{ config, pkgs, pkgs-unstable, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      style = "plain";
    };
  };

  # Zoxide, a faster way to navigate the filesystem
  # https://github.com/ajeetdsouza/zoxide
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.zoxide.enable
  programs.zoxide.enable = true;

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
    # https://github.com/malob/nixpkgs/blob/d930a2e7749248a0b0af7d025d667030011fa7b8/home/packages.nix
    # some basics
    curl
    wget

    # Cool stuff
    bat
    doggo
    du-dust
    exa
    fd
    fortune
    gh
    gnupg
    mutt
    pydf
    ripgrep
    silver-searcher
    thefuck
    tree
    xz
    inetutils

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
    isort
    jq
    nodePackages.alex
    nodePackages.markdownlint-cli
    nodePackages.prettier
    # XXX textlint doesn't foudn the terminology rule
    # pkgs-unstable.nodePackages.textlint
    # pkgs-unstable.nodePackages.textlint-rule-terminology
    nodejs
    # podman
    pylint
    qemu
    stylua

    # LSP servers
    pkgs-unstable.ansible-language-server
    pyright
    rnix-lsp
    sumneko-lua-language-server
    nodePackages.yaml-language-server
    ltex-ls
    # Required for ltex-ls usage in neovim
    jdk11
    nodePackages.bash-language-server
    nodePackages.vim-language-server
    pkgs-unstable.nodePackages.vscode-json-languageserver
    # Not yet in nixpkgs: https://github.com/NixOS/nixpkgs/pull/193682
    pkgs-unstable.marksman
    nodePackages.write-good

    # Useful nix related tools
    # cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    niv # easy dependency management for nix projects
    nodePackages.node2nix
  ] ++ lib.optionals stdenv.isLinux [
    dracula-theme
    nextcloud-client
    lm_sensors
    liquidctl
    gparted
    arch-install-scripts
    nitrokey-app
    # XXX not working
    # nixpkgs-unstable.pynitrokey
    libreoffice-still
  ] ++ lib.optionals stdenv.isDarwin [
    coreutils
    ncurses
    m-cli # useful macOS CLI commands
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
