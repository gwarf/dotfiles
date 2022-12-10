{ pkgs, lib, ... }:
{
  # Nix configuration
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
    # XXX only needed for darwin
    # terminal-notifier
    git
    wget
    vim
    # XXX breaking nix build on Darwin
    # error: Package ‘firefox-107.0.1’ in /nix/store/...firefox/wrapper.nix:404
    # is not supported on ‘x86_64-darwin’, refusing to evaluate.
    # firefox
  ];

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

  # macOS system configuration
  system.defaults = {
     dock = {
       autohide = true;
       orientation = "left";
       showhidden = true;
       mineffect = "scale";
       launchanim = true;
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
       # https://apple.stackexchange.com/questions/261163/default-value-for-nsglobaldomain-initialkeyrepeat#288764
      # lower is slower
      # defaults read NSGlobalDomain InitialKeyRepeat
       InitialKeyRepeat = 25;
      # defaults read NSGlobalDomain KeyRepeat
      # lower is faster
       KeyRepeat = 4;
       NSAutomaticCapitalizationEnabled = false;
       NSAutomaticDashSubstitutionEnabled = false;
       NSAutomaticPeriodSubstitutionEnabled = false;
       NSAutomaticQuoteSubstitutionEnabled = false;
       NSAutomaticSpellingCorrectionEnabled = false;
       NSNavPanelExpandedStateForSaveMode = true;
       NSNavPanelExpandedStateForSaveMode2 = true;
     };
   };

  # Exmaple on user postActivation scripts
  # system.activationScripts.postActivation.text = ''
  #   printf "disabling spotlight indexing... "
  #   mdutil -i off -d / &> /dev/null
  #   mdutil -E / &> /dev/null
  #   echo "ok"
  # "";
}