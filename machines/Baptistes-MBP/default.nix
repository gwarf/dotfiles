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

      # XXX: mail setup to be moved to a module
      "gpgme"
      "isync"
      "khal"
      "msmtp"
      "mutt"

      # XXX: install from pkgs does not work
      "checkmake"
      "joplin-cli"

      "bitwarden-cli"
      "fetch-crl"
      "perltidy"
      "pyenv"
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
      "stretchly"
      "teamviewer"
      "vlc"
    ];
  };
}
