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
    alacritty
    ueberzugpp
    black
    doggo
    # Disk usage
    du-dust
    # df replacement
    duf
    # ls replacement
    lsd
    fd
    fortune
    pkgs-unstable.fzf
    pkgs-unstable.gh
    gnupg
    httpie
    inetutils
    mutt
    nmap
    notmuch
    notmuch-mutt
    pkgs-unstable.obsidian
    ripgrep
    silver-searcher
    tailspin
    # thefuck
    tig
    tree
    unzip
    vdirsyncer
    xz

    # Graphical tools
    # XXX joplin-cli build failing on macOS
    # joplin
    # nodePackages.joplin
    # nodePackages_latest.joplin

    # Useful nix related tools
    # cachix # adding/managing alternative binary caches hosted by Cachix
    # comma # run software from without installing it
    niv # easy dependency management for nix projects
    nodePackages.node2nix
  ] ++ lib.optionals stdenv.isLinux [
    arch-install-scripts
    boxes
    checkmake
    pkgs-unstable.calaos_installer
    dracula-theme
    drawio
    gparted
    # Mail
    khal
    # pkgs-unstable.joplin-desktop
    liquidctl
    llvm
    lm_sensors
    nextcloud-client
    nitrokey-app
    # XXX not working
    # nixpkgs-unstable.pynitrokey
    dict
    # XXX: comment if having space issues
    # libreoffice-still
    perl
    perlPackages.PerlTidy
    vlc
    # perl536Packages.PerlTidy
    python3Packages.flake8
    shfmt
    tree-sitter
    xclip
    xorg.xkill
    # For home assistant
    mqttui
    # For FreeBSD bhyve VMs
    tigervnc
  ] ++ lib.optionals stdenv.isDarwin [
    coreutils
    m-cli # useful macOS CLI commands
    ncurses
    # Mail
    # XXX: missing full mail stack configuration
    pkgs-unstable.aerc
    mutt
    gnupg
    gpgme
    isync
    msmtp
    notmuch
    rbw
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
