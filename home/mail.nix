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
    w3m
  ];

  # Enable static configuration files
  home.file.".mailcap".source = ../modules/home/mail/mailcap-linux;
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
    # basic features working
    aerc = {
      enable = true;
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
    thunderbird = {
      enable = true;
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
        enable = true;
        profiles = [ "Perso" ];
      };
      neomutt = {
        enable = true;
        extraConfig = ''
          # Sorting
          set sort = threads
          set sort_aux = reverse-last-date-received
          # thread based on regex
          set sort_re
          set reply_regexp = "^(([Rr][Ee]?(\[[0-9]+\])?: *)?(\[[^]]+\] *)?)*"

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
          alternative_order text/calendar text/plain text/enriched text/html

          # Colors
          color body          brightblue        black        "(baptiste|grenier|gwarf)"
          color normal        cyan            black
          color error         color160        black
          color tilde         color235        black
          color message       brightmagenta         black
          color markers       color160        color254
          color attachment    color254        black
          color search        color61         black
          #color status        J_black         J_status
          color status        cyan        color235
          #color status cyan default
          color indicator     black        brightblue
          # arrow in threads
          color tree          brightblue        black
          # basic monocolor screen
          mono  bold          bold
          mono  underline     underline
          mono  indicator     reverse
          mono  error         bold
          color index         color160        black        "~A"                        # all messages
          color index         color166        black        "~E"                        # expired messages
          color index         color33         black        "~N"                        # new messages
          color index         color33         black        "~O"                        # old messages
          color index         color61         black        "~Q"                        # messages that have been replied to
          color index         color240        black        "~R"                        # read messages
          color index         color33         black        "~U"                        # unread messages
          color index         color33         black        "~U~$"                      # unread, unreferenced messages
          color index         cyan        black        "~v"                        # messages part of a collapsed thread
          color index         cyan        black        "~P"                        # messages from me
          color index         brightmagenta         black        "~p!~F"                     # messages to me
          color index         brightmagenta         black        "~N~p!~F"                   # new messages to me
          color index         brightmagenta         black        "~U~p!~F"                   # unread messages to me
          color index         color240        black        "~R~p!~F"                   # messages to me
          color index         color160        black        "~F"                        # flagged messages
          color index         color160        black        "~F~p"                      # flagged messages to me
          color index         color160        black        "~N~F"                      # new flagged messages
          color index         color160        black        "~N~F~p"                    # new flagged messages to me
          color index         color160        black        "~U~F~p"                    # new flagged messages to me
          color index         color235        color160        "~D"                        # deleted messages
          color index         color245        black        "~v~(!~N)"                  # collapsed thread with no unread
          color index         brightblue        black        "~v~(~N)"                   # collapsed thread with some unread
          color index         color64         black        "~N~v~(~N)"                 # collapsed thread with unread parent
          # statusbg used to indicated flagged when foreground color shows other status
          # for collapsed thread
          color index         color160        color235        "~v~(~F)!~N"                # collapsed thread with flagged, no unread
          color index         brightblue        color235        "~v~(~F~N)"                 # collapsed thread with some unread & flagged
          color index         color64         color235        "~N~v~(~F~N)"               # collapsed thread with unread parent & flagged
          color index         color64         color235        "~N~v~(~F)"                 # collapsed thread with unread parent, no unread inside, but some flagged
          color index         brightmagenta         color235        "~v~(~p)"                   # collapsed thread with unread parent, no unread inside, some to me directly
          color index         brightblue        color160        "~v~(~D)"                   # thread with deleted (doesn't differentiate between all or partial)
          #color index         brightblue        black        "~(~N)"                    # messages in threads with some unread
          #color index         color64         black        "~S"                       # superseded messages
          color index         color160        black        "~T"                       # tagged messages
          #color index         color166        color160        "~="                       # duplicated messages
          # message headers ------------------------------------------------------
          #color header        color240        black        "^"
          color hdrdefault    color240        black
          color header        color33        black        "^(From)"
          color header        color33         black        "^(Subject)"
          # body -----------------------------------------------------------------
          color quoted        color33         black
          color quoted1       brightmagenta         black
          color quoted2       brightblue        black
          color quoted3       color160        black
          color quoted4       color166        black
          color signature     color240        black
          color bold          color235        black
          color underline     color235        black
          color normal        color244        black
          #
          color body          color245        black        "[;:][-o][)/(|]"    # emoticons
          color body          color245        black        "[;:][)(|]"         # emoticons
          color body          color245        black        "[*]?((N)?ACK|CU|LOL|SCNR|BRB|BTW|CWYL|\
                                                               |FWIW|vbg|GD&R|HTH|HTHBE|IMHO|IMNSHO|\
                                                               |IRL|RTFM|ROTFL|ROFL|YMMV)[*]?"
          color body          color245        black        "[ ][*][^*]*[*][ ]?" # more emoticon?
          color body          color245        black        "[ ]?[*][^*]*[*][ ]" # more emoticon?
          ## pgp
          color body          color160        black        "(BAD signature)"
          color body          brightmagenta         black        "(Good signature)"
          color body          black        color234        "^gpg: Good signature .*"
          color body          cyan        black        "^gpg: "
          color body          cyan        color160        "^gpg: BAD signature from.*"
          mono  body          bold                            "^gpg: Good signature"
          mono  body          bold                            "^gpg: BAD signature from.*"
          # yes, an insance URL regex
          color body          color160        black        "([a-z][a-z0-9+-]*://(((([a-z0-9_.!~*'();:&=+$,-]|%[0-9a-f][0-9a-f])*@)?((([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?|[0-9]+\\.[0-9]+\\.[0-9]+\\.[0-9]+)(:[0-9]+)?)|([a-z0-9_.!~*'()$,;:@&=+-]|%[0-9a-f][0-9a-f])+)(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*(/([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*(;([a-z0-9_.!~*'():@&=+$,-]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?(#([a-z0-9_.!~*'();/?:@&=+$,-]|%[0-9a-f][0-9a-f])*)?|(www|ftp)\\.(([a-z0-9]([a-z0-9-]*[a-z0-9])?)\\.)*([a-z]([a-z0-9-]*[a-z0-9])?)\\.?(:[0-9]+)?(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*(/([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*(;([-a-z0-9_.!~*'():@&=+$,]|%[0-9a-f][0-9a-f])*)*)*)?(\\?([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?(#([-a-z0-9_.!~*'();/?:@&=+$,]|%[0-9a-f][0-9a-f])*)?)[^].,:;!)? \t\r\n<>\"]"
          # and a heavy handed email regex
          color body          color160        black        "((@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]),)*@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\.[0-9]?[0-9]?[0-9]\\]):)?[0-9a-z_.+%$-]+@(([0-9a-z-]+\\.)*[0-9a-z-]+\\.?|#[0-9]+|\\[[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\.[0-2]?[0-9]?[0-9]\\])"
          # Various smilies and the like
          #color body          color230        black        "<[Gg]>"                            # <g>
          #color body          color230        black        "<[Bb][Gg]>"                        # <bg>
          #color body          brightblue        black        " [;:]-*[})>{(<|]"                  # :-) etc...
          # *bold*
          color body          color33         black        "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
          mono  body          bold                            "(^|[[:space:][:punct:]])\\*[^*]+\\*([[:space:][:punct:]]|$)"
          # _underline_
          color body          color33         black        "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
          mono  body          underline                       "(^|[[:space:][:punct:]])_[^_]+_([[:space:][:punct:]]|$)"
          # /italic/  (Sometimes gets directory names)
          color body         color33         black        "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"
          mono body          underline                       "(^|[[:space:][:punct:]])/[^/]+/([[:space:][:punct:]]|$)"
          # Border lines.
          #color body          color33         black        "( *[-+=#*~_]){6,}"
          #folder-hook .                  "color status        J_black         J_status        "
          #folder-hook gmail/inbox        "color status        J_black         brightblue        "
          #folder-hook gmail/important    "color status        J_black         brightblue        "
          # patch/diff
          color body green      default "^diff \-.*"
          color body green      default "^index [a-f0-9].*"
          color body green      default "^\-\-\- .*"
          color body green      default "^[\+]{3} .*"
          color body cyan       default "^[\+][^\+]+.*"
          color body red        default "^\-[^\-]+.*"
          color body brightblue default "^@@ .*"
        '';
      };
    };
  };
}
