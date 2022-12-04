## TODO
# - keybase
# - nextcloud
# - i3 config: minimal: cpu temp in bar
# - access email (mutt, isync, notmuch)
{ config, pkgs, lib, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # Bat, a substitute for cat.
  # https://github.com/sharkdp/bat
  # https://rycee.gitlab.io/home-manager/options.html#opt-programs.bat.enable
  programs.bat.enable = true;
  programs.bat.config = {
    style = "plain";
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
    # Cool stuff
    gnupg
    mutt
    fortune
    bat
    exa
    fd
    ripgrep
    du-dust
    tealdeer
    thefuck
    xz
    dracula-theme
    tree
    nextcloud-client
    silver-searcher

    # Dev stuff
    jq
    nodejs
    # XXX not available
    nodePackages.alex
    actionlint
    black
    beautysh
    isort
    stylua
    # XXX not available
    nodePackages.markdownlint-cli
    pylint
    # XXX not available
    # prettier
    shellcheck
    shfmt
    # LSP servers
    # XXX not available
    # ansible-language-server
    # bash-language-server
    # json-lsp
    ltex-ls
    # XXX not available
    # marksman
    pyright
    sumneko-lua-language-server
    # vim-language-server
    yaml-language-server

  ] ++ lib.optionals stdenv.isDarwin [
    coreutils
    m-cli # useful macOS CLI commands
  ];
}
