{ lib, ... }:
{
  imports = [
    ./configuration-Baptistes-MBP.nix
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
      "isync"
      "mutt"
      "msmtp"
      "gpgme"

      # XXX install from pkgs does not work
      "joplin-cli"
    ];
    casks = [
      "rectangle"
    ];
};
}
