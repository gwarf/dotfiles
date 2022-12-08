{ pkgs, lib, ... }:
{
  imports = [
    ../../modules/system/yabai
  ];
  # Nix configuration ------------------------------------------------------------------------------

  nix.settings.substituters = [
    "https://cache.nixos.org/"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];
  nix.settings.trusted-users = [
    "@admin"
  ];
  nix.configureBuildUsers = true;

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.zsh.enable = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  # Apps
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    kitty
    # XXX only needed for darwin
    # terminal-notifier
    git
    wget
    vim
    # XXX breaking nix build on Darwin
    # error: Package ‘firefox-107.0.1’ in /nix/store/m3kyxfqm6545gb7xhwnsjrsnjj86wmsf-source/pkgs/applications/networking/browsers/firefox/wrapper.nix:404 is not supported on ‘x86_64-darwin’, refusing to evaluate.
    # firefox
  ];

  # https://github.com/nix-community/home-manager/issues/423
  # environment.variables = {
  #   TERMINFO_DIRS = "${pkgs.kitty.terminfo.outPath}/share/terminfo";
  # };
  programs.nix-index.enable = true;

  # Fonts
  fonts.fontDir.enable = true;
  # https://github.com/lightdiscord/nix-nerd-fonts-overlay
  # https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix#L2-L51
  fonts.fonts = with pkgs; [
    fantasque-sans-mono
    font-awesome_5
    recursive
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" ]; })
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    libertine
    victor-mono
    kochi-substitute
   ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  system.defaults = {
     dock = {
       autohide = true;
       orientation = "right";
       showhidden = true;
       mineffect = "scale";
       launchanim = false;
       show-process-indicators = true;
       tilesize = 48;
       static-only = true;
       mru-spaces = false;
     };
     finder = {
       AppleShowAllExtensions = true;
       FXEnableExtensionChangeWarning = false;
     };
     trackpad = {
       Clicking = true;
       TrackpadThreeFingerDrag = true;
     };
     NSGlobalDomain = {
       AppleKeyboardUIMode = 3;
       ApplePressAndHoldEnabled = false;
       InitialKeyRepeat = 10;
       KeyRepeat = 1;
       NSAutomaticCapitalizationEnabled = false;
       NSAutomaticDashSubstitutionEnabled = false;
       NSAutomaticPeriodSubstitutionEnabled = false;
       NSAutomaticQuoteSubstitutionEnabled = false;
       NSAutomaticSpellingCorrectionEnabled = false;
       NSNavPanelExpandedStateForSaveMode = true;
       NSNavPanelExpandedStateForSaveMode2 = true;
     };
   };

  # Add ability to used TouchID for sudo authentication
  # security.pam.enableSudoTouchIdAuth = true;
}