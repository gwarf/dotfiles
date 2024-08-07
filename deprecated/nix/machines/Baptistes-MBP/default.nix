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
      # For aerc, to replace mutt?
      "lolcat"
      "pandoc"
      "dante"

      # XXX: for building norg-treesitter on macOS
      # https://github.com/nvim-neorg/tree-sitter-norg/issues/7
      # "gcc@12"

      # XXX: install from pkgs does not work
      "checkmake"
      "khal"
      # "joplin-cli"

      "gnu-sed"

      "bitwarden-cli"
      "fetch-crl"
      "ldapvi"
      "perltidy"
      "pyenv"
      "flake8"
      # https://dev.languagetool.org/http-server
      "languagetool"

      "terminal-notifier"

      # Terminal file manager
      "yazi"
    ];
    casks = [
      # app launcher, file searcher
      "alfred"
      # XXX: install from pkgs does not work
      "drawio"
      # "joplin"
      # Clipboard manager
      "maccy"
      "mumble"
      # "podman-desktop"
      "rectangle"
      "slack"
      "stretchly"
      "teamviewer"
      "vagrant"
      "virtualbox"
      "vlc"
      "wezterm"
    ];
  };
}
