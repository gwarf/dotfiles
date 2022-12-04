{ pkgs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration-brutal.nix
    ];

  # Use system-boot
  boot = {
    # Enable magic sysrql (Alt+PrtSc) keys for recovery
    kernel.sysctl = { "kernel.sysrq" = 1; };
    kernelPackages = pkgs.linuxPackages_latest;
    cleanTmpDir = true;
    # plymouth.enable = true;
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "max";
    loader.efi.canTouchEfiVariables = true;
  };

  # boot.loader.systemd-boot.consoleMode = "keep";
  networking = {
    hostName = "brutal"; # Define your hostname.
    networkmanager.enable = true;  # Easiest to use and most distros use this by default.
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_GB.UTF-8";
    supportedLocales = [ "fr_FR.UTF-8/UTF-8" "en_GB.UTF-8/UTF-8" "en_US.UTF-8/UTF-8" ];
  };

  # Manage graphical environment
  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.defaultSession = "none+i3";

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "caps:escape";  # map caps to escape.
  # "eurosign:e";  # map caps to escape.

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.baptiste = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.fish;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # Automatic upgrade
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;

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

  # Enable experimental nix command and flakes
  # nix.package = pkgs.nixUnstable;
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
  '';

  # Apps
  programs.zsh.enable = true;
  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Some basics
    curl
    git
    gh
    lm_sensors
    mcelog
    vim
    wget
  ];

  # Fonts
  fonts.fontDir.enable = true;
  # https://github.com/lightdiscord/nix-nerd-fonts-overlay
  # https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix#L2-L51
  # https://github.com/JonathanReeve/dotfiles/blob/master/dotfiles/configuration.nix#L61
  fonts.fonts = with pkgs; [
    fantasque-sans-mono
    font-awesome_5
    # Only pick selected fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" ]; })
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
}
