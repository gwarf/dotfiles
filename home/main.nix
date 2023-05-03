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

    # FIXME: not working for getting norg-treesitter to build
    # neovim :Neorg sync-parsers
    # clang and llvm
    # clang
    # llvm
    # clang-tools
    # pkg-config
    # clang_14
    # clang-tools_14
    # lld_14
    # llvmPackages_14.stdenv
    # llvmPackages_14.llvm
    # llvmPackages_14.clang
    # llvmPackages_14.libcxx
    # llvmPackages_14.libcxxabi
    # llvmPackages_14.clang-unwrapped
    # llvmPackages_14.clangUseLLVM
    # llvmPackages_14.libcxxStdenv
    # llvmPackages_14.libcxxClang
    # llvmPackages_14.libclang
    # llvmPackages_14.bintools

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
    unzip

    # Graphical tools
    # XXX joplin-cli build failing on macOS
    # joplin
    # nodePackages.joplin
    # nodePackages_latest.joplin
    joplin-desktop

    # Useful nix related tools
    # cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    niv # easy dependency management for nix projects
    nodePackages.node2nix
  ] ++ lib.optionals stdenv.isLinux [
    arch-install-scripts
    checkmake
    dracula-theme
    drawio
    gparted
    # Mail
    khal
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
    xclip
  ] ++ lib.optionals stdenv.isDarwin [
    coreutils
    m-cli # useful macOS CLI commands
    ncurses
    # Mail
    # XXX: need to take care of configuration
    mutt
    gnupg
    gpgme
    # XXX: need to take care of daemon
    isync
    # XXX: need to take care of daemon
    msmtp
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
