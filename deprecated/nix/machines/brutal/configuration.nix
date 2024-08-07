{ pkgs, lib, ... }:
{
  # Use system-boot
  boot = {
    # Enable magic sysrql (Alt+PrtSc) keys for recovery
    kernel.sysctl = { "kernel.sysrq" = 1; };
    kernelPackages = pkgs.linuxPackages_latest;
    # kernelModules = [ "edac_mce_amd" ];
    tmp.cleanOnBoot = true;
    plymouth.enable = false;
    loader.systemd-boot.enable = true;
    loader.systemd-boot.consoleMode = "max";
    loader.efi.canTouchEfiVariables = true;
    loader.systemd-boot.memtest86.enable = true;
    loader.systemd-boot.configurationLimit = 10;
  };

  # boot.loader.systemd-boot.consoleMode = "keep";
  networking = {
    hostName = "brutal"; # Define your hostname.
    networkmanager.enable = true; # Easiest to use and most distros use this by default.
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
  # Lightweight system
  services.xserver.displayManager.lightdm.enable = false;
  services.xserver.windowManager.i3.enable = true;
  # services.xserver.displayManager.defaultSession = "none+i3";
  # GDM and Gnome
  services.displayManager.defaultSession = "gnome";
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";
  services.xserver.xkb.options = "caps:escape"; # map caps to escape.
  # "eurosign:e";  # map caps to escape.

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ gutenprint cups-filters ];
  };
  # Help with printer auto discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
  };

  # Allow access to watercooling devices
  services.udev.extraRules = ''
    # https://github.com/liquidctl/liquidctl/blob/main/extra/linux/71-liquidctl.rules
    # Aquacomputer D5 Next
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c70", ATTRS{idProduct}=="f00e", TAG+="uaccess"
    # Aquacomputer Farbwerk 360
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c70", ATTRS{idProduct}=="f010", TAG+="uaccess"
    # Aquacomputer Octo
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c70", ATTRS{idProduct}=="f011", TAG+="uaccess"
    # Aquacomputer Quadro
    SUBSYSTEMS=="usb", ATTRS{idVendor}=="0c70", ATTRS{idProduct}=="f00d", TAG+="uaccess"
  '';

  # gnome-keyring-daemon is correctly started in user session
  # but apparently SSH_AUTH_SOCK is missing :/
  security.pam.services.lightdm.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  security.polkit.enable = true;
  programs.dconf.enable = true;

  # hardware logging
  hardware.rasdaemon.enable = true;

  # nitrokey
  hardware.nitrokey.enable = true;

  # Enable sound.
  # https://nixos.wiki/wiki/PulseAudio
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;
  nixpkgs.config.pulseaudio = true;
  hardware.pulseaudio.extraConfig = "load-module module-combine-sink";
  hardware.pulseaudio.package = pkgs.pulseaudioFull;

  # Fish is required
  programs.fish.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.baptiste = {
    isNormalUser = true;
    extraGroups = [
      "audio"
      "wheel" # Enable ‘sudo’ for the user.
      "nitrokey"
    ];
    shell = pkgs.fish;
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # XXX not working with flakes
  # https://github.com/NixOS/nixpkgs/issues/97252
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  # Automatic upgrade
  # XXX not working, need to find proper way to automatise this
  system.autoUpgrade = {
    enable = false;
    flags = [
      "--update-input"
      "nixpkgs"
      "--commit-lock-file"
      "--flake"
      "/home/baptiste/repos/dotfiles"
    ];
    allowReboot = false;
  };

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
  nix.gc = {
    automatic = true;
    options = "--delete-older-than 60d";
  };

  # Enable experimental nix command and flakes
  # Protect against gc of nix-shell
  nix.extraOptions = ''
    auto-optimise-store = true
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    # Some basics
    git
    vim
    wget
    # For gnome
    gnome.gnome-tweaks
  ];

  # Fonts
  fonts.fontDir.enable = true;
  # XXX: try to move to home/main.nix
  # https://github.com/lightdiscord/nix-nerd-fonts-overlay
  # https://github.com/NixOS/nixpkgs/blob/6ba3207643fd27ffa25a172911e3d6825814d155/pkgs/data/fonts/nerdfonts/shas.nix#L2-L51
  # https://github.com/JonathanReeve/dotfiles/blob/master/dotfiles/configuration.nix#L61
  fonts.packages = with pkgs; [
    # Only pick selected fonts
    (nerdfonts.override { fonts = [ "CascadiaCode" "JetBrainsMono" ]; })
    fantasque-sans-mono
    fira-code
    fira-code-symbols
    font-awesome_5
    kochi-substitute
    libertine
    material-design-icons
    material-icons
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    recursive
    victor-mono
  ];
}
