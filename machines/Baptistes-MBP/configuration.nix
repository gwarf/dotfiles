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

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 60d";
  };

  # Enable experimental nix command and flakes
  # Protect against gc of nix-shell
  # XXX disable auto-optimise-store
  # see https://github.com/NixOS/nix/issues/7273#issuecomment-1450809740
  # 'nix store optimise' should be run manually
  nix.extraOptions = ''
    auto-optimise-store = false
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  programs.nix-index.enable = true;

  # List packages installed in system profile.
  # `home-manager` currently has issues adding them to `~/Applications`
  # Issue: https://github.com/nix-community/home-manager/issues/1341
  environment.systemPackages = with pkgs; [
    # Some basics
    git
    vim
    wget
    # For mutt, to be moved to mail module
    w3m
  ];

  # Fonts
  # XXX: try to move to home/main.nix
  # https://github.com/lightdiscord/nix-nerd-fonts-overlay
  # https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix#L2-L51
  # https://github.com/JonathanReeve/dotfiles/blob/master/dotfiles/configuration.nix#L61
  fonts.packages = with pkgs; [
    fantasque-sans-mono
    font-awesome_5
    # Only pick selected fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" ]; })
    material-design-icons
    material-icons
    # pkgs-unstable.material-symbols
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    fira-code
    fira-code-symbols
    libertine
    victor-mono
    kochi-substitute
    recursive
  ];

  # Keyboard
  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  # Define a user account
  users.users.baptiste = {
    # https://github.com/nix-community/home-manager/issues/4026
    home = "/Users/baptiste";
  };

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

  # https://github.com/elobdog/mailhelp/blob/master/homebrew.mxcl.isync.plist
  # Mail configuration
  # XXX move to home-manager
  launchd.user.agents.mbsync = {
    # XXX not yet deployed/managed via nix
    serviceConfig.Program = "/Users/baptiste/.config/neomutt/sync";
    serviceConfig.RunAtLoad = true;
    serviceConfig.StartInterval = 300;
    serviceConfig.StandardErrorPath = "/Users/baptiste/Mail/.mailsync_error.log";
    serviceConfig.StandardOutPath = "/Users/baptiste/Mail/.mailsync_out.log";
    serviceConfig.ProcessType = "Background";
  };
  # Sync of contacts
  # XXX: describe the vdirsyncer configuration from ~/.config/vdirsyncer/config
  # https://search.nixos.org/options?channel=23.05&show=services.vdirsyncer.jobs.%3Cname%3E.configFile&from=0&size=50&sort=relevance&type=packages&query=vdirsyncer
  # https://github.com/pSub/configs/blob/21c3413cf0f5f39ec118cbbf34704192615c40ca/nixops/configurations/server.pascal-wittmann.de/default.nix#L402
  launchd.user.agents.vdirsyncer = {
    serviceConfig.Program = "${pkgs.vdirsyncer}/bin/vdirsyncer";
    serviceConfig.ProgramArguments = [
      "--verbosity CRITICAL"
      "sync"
    ];
    serviceConfig.RunAtLoad = true;
    serviceConfig.StartInterval = 3600;
    serviceConfig.StandardErrorPath = "/Users/baptiste/Mail/.vdirsyncer.log";
    serviceConfig.StandardOutPath = "/Users/baptiste/Mail/.vdirsyncer.log";
    serviceConfig.ProcessType = "Background";
    serviceConfig.Nice = -10;
    serviceConfig.LowPriorityIO = true;
  };
}
