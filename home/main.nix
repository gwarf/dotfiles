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
    gnupg
    mutt
    fortune
    bat
    gh
    exa
    fd
    ripgrep
    du-dust
    thefuck
    xz
    tree
    silver-searcher
    pydf

    # Graphical tools
    # XXX joplin-cli build failing on macOS
    # joplin
    # nodePackages.joplin
    # nodePackages_latest.joplin
    joplin-desktop

    # Dev stuff
    jq
    nodejs
    podman
    nodePackages.alex
    actionlint
    black
    beautysh
    isort
    stylua
    nodePackages.markdownlint-cli
    pylint
    nodePackages.prettier
    shellcheck
    shfmt
    ansible-lint

    # LSP servers
    pyright
    sumneko-lua-language-server
    pkgs-unstable.ansible-language-server
    yaml-language-server
    rnix-lsp
    ltex-ls
    # Required for ltex-ls usage in neovim
    jdk11
    nodePackages.vim-language-server
    nodePackages.bash-language-server
    pkgs-unstable.nodePackages.vscode-json-languageserver
    # XXX not yet available: https://github.com/NixOS/nixpkgs/pull/193682
    # marksman

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
