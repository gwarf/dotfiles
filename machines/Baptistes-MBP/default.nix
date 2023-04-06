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
      "the_silver_searcher"

      # mail setup
      # XXX to be moved to a module
      "gpgme"
      "isync"
      "msmtp"
      "mutt"

      # XXX install from pkgs does not work
      "joplin-cli"
      # To be used for nvim/treesitter/neorg with recent C++
      "llvm"

      "bitwarden-cli"
      "checkmake"
      "fetch-crl"
      "perltidy"
      "pyenv"
    ];
    casks = [
      # app launcher, file searcher
      "alfred"
      # Clipboard manager
      "maccy"
      "mumble"
      # "podman-desktop"
      "rectangle"
      "stretchly"
      "vlc"
    ];
  };
}
