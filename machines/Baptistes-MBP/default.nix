{ lib, ... }:
{
  imports = [
    ./configuration.nix
    ../../modules/system/yabai
  ];
  homebrew = {
    enable = true;
    onActivation.autoUpdate = true;
    # updates homebrew packages on activation,
    # can make darwin-rebuild much slower
    onActivation.upgrade = true;
    brews = [
      "terminal-notifier"

      # XXX: for building norg-treesitter on macOS
      # https://github.com/nvim-neorg/tree-sitter-norg/issues/7
      # "gcc@12"

      # XXX: install from pkgs does not work
      "checkmake"
      "khal"
      "joplin-cli"

      "bitwarden-cli"
      "fetch-crl"
      "perltidy"
      "pyenv"
      "flake8"
    ];
    casks = [
      # app launcher, file searcher
      "alfred"
      # XXX: install from pkgs does not work
      "drawio"
      # Clipboard manager
      "maccy"
      "mumble"
      # "podman-desktop"
      "rectangle"
      "slack"
      "stretchly"
      "teamviewer"
      "vlc"
    ];
  };
}
