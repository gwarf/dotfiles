# https://github.com/ShadowRZ/flakes/blob/master/nixos/configuration.nix
{ config, lib, pkgs, pkgs-unstable, ... }:

let
  inherit (config.home.user-info) username;
  inherit (config.home.user-info) fullName;
  inherit (config.home.user-info) email;
in
{
  home.packages = with pkgs; [
    # XXX: broken on NixOS 2023-10-28
    pkgs-unstable.bitwarden
    bitwarden-cli
    pkgs-unstable.rbw
    # pinentry-gtk2
    pkgs-unstable.himalaya
    pkgs-unstable.aerc
    #vimPlugins.himalaya-vim
    mutt
    neomutt
    msmtp
    isync
    w3m
    # XXX: 2024006022: deprecated, replace by extract_url urlscan
    # urlview
    extract_url
  ];

  # Enable static configuration files
  home.file.".mailcap".source = ./mailcap-linux;
  home.file.".config/neomutt/colors".source = ./colors-solarized-dark-256.muttrc;
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

  # Manage programs
  programs = {

    # aerc: basic features working
    aerc = {
      # XXX: installed from unstable with home-manager
      enable = false;
      extraBinds = {
        global = {
          "<C-p>" = ":prev-tab<Enter>";
          "<C-n>" = ":next-tab<Enter>";
          "<C-t>" = ":term<Enter>";
        };
        messages = {
          q = ":quit<Enter>";
          j = ":next<Enter>";
        };
        "compose::editor" = {
          "$noinherit" = "true";
          "$ex" = "<C-x>";
          "<C-k>" = ":prev-field<Enter>";
        };
      };
      extraConfig = {
        general.unsafe-accounts-conf = true;
        ui = {
          # index-format = null;
          enable-folders-sort = true;
          sort = "-r date";
          spinner = [ true 2 3.4 "5" ];
          sidebar-width = 42;
          mouse-enabled = false;
          test-float = 1337.42;
        };
      };
      stylesets = {
        asLines = ''
          *.default = true
          *.selected.reverse = toggle
          *error.bold = true
          error.fg = red
          header.bold = true
          title.reverse = true
        '';
        default = {
          "*.default" = "true";
          "*error.bold" = "true";
          "error.fg" = "red";
          "header.bold" = "true";
          "*.selected.reverse" = "toggle";
          "title.reverse" = "true";
        };
      };
      templates = rec {
        foo = ''
          X-Mailer: aerc {{version}}
          Just a test.
        '';
        bar = foo;
      };
    };

    # Thunderird: working with imap
    thunderbird = {
      enable = false;
      profiles = {
        Perso = {
          isDefault = true;
          withExternalGnupg = true;
        };
      };
      settings = {
        "privacy.donottrackheader.enabled" = true;
      };
    };
    # failing to build tomly cofniguration
    # himalaya.enable = true;
    # basic configuration working
    neomutt = {
      enable = true;
      # interfers with some manually configured bindings
      vimKeys = false;
      binds = [
        {
          action = "complete-query";
          key = "<Tab>";
          map = [ "editor" ];
        }
        {
          action = "group-reply";
          key = "R";
          map = [ "pager" ];
        }
        {
          action = "flag-message";
          key = "F";
          map = [ "index" "pager" ];
        }
        {
          action = "half-down";
          key = "\\Cd";
          map = [ "pager" ];
        }
        {
          action = "half-down";
          key = "\\Cn";
          map = [ "pager" ];
        }
        {
          action = "half-up";
          key = "\\Cp";
          map = [ "pager" ];
        }
        {
          action = "half-up";
          key = "\\Cu";
          map = [ "pager" ];
        }
        {
          # unbind g to get gg working
          action = "noop";
          key = "g";
          map = [ "attach" "browser" "index" "pager" ];
        }
        {
          action = "first-entry";
          key = "gg";
          map = [ "index" ];
        }
        {
          action = "top";
          key = "gg";
          map = [ "pager" ];
        }
        {
          action = "bottom";
          key = "G";
          map = [ "pager" ];
        }
        {
          action = "last-entry";
          key = "G";
          map = [ "index" ];
        }
        {
          action = "current-top";
          key = "zt";
          map = [ "index" ];
        }
        {
          action = "current-middle";
          key = "zz";
          map = [ "index" ];
        }
        {
          action = "current-bottom";
          key = "zb";
          map = [ "index" ];
        }
        {
          action = "toggle-new";
          key = "N";
          map = [ "index" ];
        }
        {
          action = "previous-line";
          key = "k";
          map = [ "pager" ];
        }
        {
          action = "next-line";
          key = "j";
          map = [ "pager" ];
        }
      ];
      macros = [
        {
          action = "<shell-escape>mbsync -a<enter>";
          key = "\\Cf";
          map = [ "index" "pager" ];
        }
        {
          action = "<save-message>+Archive<enter>";
          key = "A";
          map = [ "index" "pager" ];
        }
        {
          action = "<save-entry><bol>~/Downloads/<eol>";
          key = "s";
          map = [ "attach" ];
        }
        {
          # Show importants mails
          action = "l(~F | ~U) ! ~D\\r";
          key = "\\'";
          map = [ "index" ];
        }
        {
          # Display smime info using openssl
          action = "<pipe-entry>openssl smime -verify -noverify -pk7out | openssl pkcs7 -print_certs |openssl x509 -subject -issuer -dates -text | less<enter>";
          key = "\\Ca";
          map = [ "index" "pager" ];
        }
      ];
    };
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
        themes_dir = "${pkgs.alot}/share/alot/themes/";
        theme = "tomorrow";
      };
    };
  };

  # Manage service
  services.mbsync = {
    enable = true;
    verbose = true;
  };

  # Manage accounts
  accounts.email = {
    #  maildirBasePath = "Mail";
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
      passwordCommand = "${config.home.profileDirectory}/bin/secret-tool lookup host mail.bapt.name service imaps user ${email}";
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
        port = 587;
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
      folders = {
        drafts = "Drafts";
        inbox = "Inbox";
        sent = "Sent";
        trash = "Trash";
      };
      notmuch.enable = true;
      msmtp = {
        enable = true;
        extraConfig = {
          logfile = "~/.msmtp.log";
        };
      };
      # Configure some clients
      aerc.enable = true;
      himalaya.enable = true;
      thunderbird = {
        enable = false;
        profiles = [ "Perso" ];
      };

      neomutt = {
        enable = true;
        extraConfig = ''
          # Prefer plain text
          alternative_order text/calendar text/plain text/enriched text/html

          # Forward message as attachement
          set mime_forward = ask-yes
          set mime_forward_rest = ask-yes

          # print is used to show html emails in browser
          set print = ask-yes

          # Bindings
          # Fetching mail
          # Some vim-like keys
          # bind pager G bottom
          # bind pager j next-line
          # bind pager k previous-line

          # Do not ask for confirmation when moving a message
          unset confirmappend
          # Ask before purging deleted messages
          set delete=ask-yes

          # Sorting
          set sort = threads
          set sort_aux = reverse-last-date-received
          # thread based on regex
          set sort_re
          set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"

          # Pager view options
          # number of index lines to show
          set pager_index_lines = 8

          # Viewing MIME
          set mailcap_path = "~/.mailcap:/etc/mailcap"
          unauto_view *
          auto_view text/html
          auto_view text/calendar application/ics
          auto_view image/x-portable
          auto_view image/x-portable-bitmap
          auto_view image/x-portable-graymap
          auto_view image/x-portable-anymap
          auto_view image/x-portable-pixmap
          auto_view application/pgp-signature
          auto_view application/pgp
          auto_view application/x-gunzip
          auto_view application/postscript
          auto_view application/x-troff-man
          auto_view application/x-troff-me
          auto_view application/x-troff
          auto_view application/x-gtar
          auto_view application/x-tar
          auto_view application/x-tar-gz
          auto_view application/x-sh
          auto_view application/x-csh
          auto_view application/x-shar
          auto_view application/x-latex
          auto_view application/x-tex
          auto_view application/x-dvi
          auto_view application/x-zip-compressed
          auto_view application/x-cpio text/richtext
          auto_view application/pgp-keys
          auto_view application/octet-stream
          auto_view text/x-vcard
          auto_view text/enriched
          auto_view text/csv

          # Headers
          # edit all headers lines in the editor
          set edit_headers
          ignore *
          unignore from date subject to cc reply-to
          unignore x-url x-resent organization
          unignore x-mailing-list list-id list-unsubscribe
          unignore user-agent x-agent x-mailer x-newsreader
          unignore newsgroups posted-to x-also-posted-to
          unignore sender x-original-sender
          unignore priority importance
          unignore mail-followup-to in-reply-to
          unignore priority x-priority importance
          # useful to debug smtp path but too verbose
          # unignore references
          # unignore content-type
          unignore message-id
          unignore tags
          unignore folder
          unhdr_order *
          hdr_order Sender: From: To: Cc: Subject: Date: Reply-To: Organization: Message-Id: User-Agent: X-Editor: X-Mailer: X-Newsreader: X-Agent:  X-Resent: Followup-To: Mail-Followup-To: Folder: Tags:

          # load colors
          source ~/.config/neomutt/colors
        '';
      };
    };
  };
}
