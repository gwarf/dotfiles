# https://github.com/ShadowRZ/flakes/blob/master/nixos/configuration.nix
{ config, lib, pkgs, ... }:

let
  inherit (config.home.user-info) username;
  inherit (config.home.user-info) fullName;
  inherit (config.home.user-info) email;
in
{
  home.packages = with pkgs; [
    bitwarden
    bitwarden-cli
    # rbw
    # pinentry-gtk2
    pinentry-gnome
    libsecret
    aerc
    himalaya
    mutt
    neomutt
    msmtp
    isync
    gnome.seahorse
    gnome.gnome-keyring
    vimPlugins.himalaya-vim
    # thunderbird
  ];
  # programs = {
  #   ### GnuPG
  #   gpg = {
  #     enable = true;
  #     settings = {
  #       personal-digest-preferences = "SHA512";
  #       cert-digest-algo = "SHA512";
  #       default-preference-list =
  #         "SHA512 SHA384 SHA256 SHA224 AES256 AES192 AES CAST5 ZLIB BZIP2 ZIP Uncompressed";
  #       personal-cipher-preferences = "TWOFISH CAMELLIA256 AES 3DES";
  #       keyid-format = "0xlong";
  #       with-fingerprint = true;
  #       trust-model = "tofu";
  #       utf8-strings = true;
  #       keyserver = "hkps://keyserver.ubuntu.com";
  #       verbose = false;
  #     };
  #   };
  # };
  #  services = {
  #   ### GnuPG Agent
  #   gpg-agent = {
  #     enable = true;
  #     extraConfig = ''
  #       allow-loopback-pinentry
  #       allow-emacs-pinentry
  #     '';
  #     pinentryFlavor = "qt";
  #   };

  # https://github.com/luisholanda/dotfiles/blob/8ee7bbabd11e50439b6f0c5a741046b990fd79b0/hosts/hermes/default.nix#L143
  # XXX Doesn't seem to be exportign the SSH_AUTH_SOCK
  # https://github.com/nix-community/home-manager/issues/1454#issuecomment-1332777643
  # services.gnome-keyring = {
  #   enable = true;
  #   components = [ "pkcs11" "secrets" "ssh" ];
  # };
  # XXX not way to do this from home-manager?
  # https://github.com/NixOS/nixpkgs/issues/174099#issuecomment-1138165212
  # https://github.com/nix-community/home-manager/issues/1454#issuecomment-850548158
  # security.pam.services.lightdm.enableGnomeKeyring = true;
  # Automatic launch doesn't work
  # XXX Working gnome-keyring-daemon is started in configuration-brutal.nix, able to use secret tool
  # xsession = {
  #   enable = true;
  #   initExtra = ''
  #     dbus-update-activation-environment --systemd DISPLAY
  #     eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
  #     export SSH_AUTH_SOCK
  #     # disable screen saver
  #     # xset s off -dpms
  #   '';
  # };
  # programs.ssh.startAgent = true;

  # should be able to work with bitwarden
  # programs.rbw = {
  #   enable = true;
  #   settings = {
  #     email = email;
  #     lock_timeout = 300;
  #     pinentry = "gnome3";
  #   };
  # };
  programs = {
    # aerc = {
    #   enable = true;
    #   extraAccounts = {
    #     Perso = {
    #       source = "maildir://~/Maildir/${username}";
    #       outgoing = "sendmail";
    #       from = "${fullName} <${email}>";
    #       enable-folders-sort = true;
    #       # folders = [ "INBOX" "Sent" "Junk" ];
    #       };
    #   };
    #   # extraBinds = { messages = { d = ":move Trash<Enter>"; }; };
    #   extraBinds = {
    #     global = {
    #       "<C-p>" = ":prev-tab<Enter>";
    #       "<C-n>" = ":next-tab<Enter>";
    #       "<C-t>" = ":term<Enter>";
    #     };
    #     messages = {
    #       q = ":quit<Enter>";
    #       j = ":next<Enter>";
    #     };
    #     "compose::editor" = {
    #       "$noinherit" = "true";
    #       "$ex" = "<C-x>";
    #       "<C-k>" = ":prev-field<Enter>";
    #     };
    #   };
    #   extraConfig = {
    #     general.unsafe-accounts-conf = true;
    #     ui = {
    #       index-format = null;
    #       sort = "-r date";
    #       # spinner = [ true 2 3.4 "5" ];
    #       # sidebar-width = 42;
    #       # mouse-enabled = false;
    #       # test-float = 1337.42;
    #     };
    #   };
    # };
    # thunderbird.enable = true;
    # himalaya = {
    #   enable = true;
    #   # backend = "maildir";
    #   # sender = "smtp";
    # };
    neomutt.enable = true;
    mbsync.enable = true;
    msmtp.enable = true;
    notmuch = {
      enable = true;
      hooks = {
        preNew = "mbsync --all";
        postNew = ''
          ${pkgs.afew}/bin/afew -a -t
        '';
      };
      new.tags = [ "new" ];
    };
    # https://github.com/ShadowRZ/flakes/blob/d021fcfd6a7068292faffcfefd64c865dbe27657/nixos/futaba/modules/email/default.nix
    afew = {
      enable = true;
      extraConfig = ''
        [SpamFilter]
        [KillThreadsFilter]
        [ArchiveSentMailsFilter]
        [InboxFilter]
        [Filter.0]
        query = from:discourse@discourse.nixos.org
        tags = +discourse;+discourse/nixos
        message = Discourse :: NixOS
        [Filter.1]
        query = from:meta@discoursemail.com
        tags = +discourse;+discourse/meta
        message = Discourse :: Discourse Meta
        [Filter.2]
        query = from:github.com
        tags = +github
        message = GitHub
        [Filter.3]
        query = to:nixpkgs@noreply.github.com
        tags = +nixpkgs
        message = Nixpkgs
      '';
    };
    alot = {
      enable = true;
      settings = {
        auto_remove_unread = true;
        handle_mouse = true;
        initial_command = "search tag:inbox AND NOT tag:killed";
        prefer_plaintext = true;
        ask_subject = false;
        thread_indent_replies = 2;
        theme = "tomorrow";
      };
    };
  };

  accounts.email = {
    accounts.${username} = {
      address = email;
      userName = email;
      primary = true;
      realName = fullName;
      signature = {
        text = ''
          Baptiste Grenier
          https://keybase.io/gwarf
        '';
        showSignature = "append";
      };
      # works but asking for password interactively
      # apparently not taking env var
      # passwordCommand = ''bw get password --session "$BW_SESSION" '/mail/baptiste@bapt.name'';
      # passwordCommand = "bw get password /mail/baptiste@bapt.name";
      # secret-tool store --label=mail host mail.bapt.name service imaps user baptiste@bapt.name
      passwordCommand = "secret-tool lookup host mail.bapt.name service imaps user ${email}";
      # gpg = {
      #   key = "0xCDA18F02";
      #   encryptByDefault = false;
      #   signByDefault = false;
      # };
      imap = {
        host = "mail.bapt.name";
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      smtp = {
        host = "mail.bapt.name";
        port = 465;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };
      # mbsync works
      mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
      # folder = {
      #   inbox = "In";
      #   sent = "Out";
      #   drafts = "Drafts";
      # };
      msmtp.enable = true;
      notmuch.enable = true;
      # Configure some clients
      aerc.enable = true;
      himalaya.enable = true;
      # thunderbird.enable = true;
      neomutt.enable = true;
    };
  };
}
