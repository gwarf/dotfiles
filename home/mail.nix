{ config, lib, pkgs, ... }:

let
  inherit (config.home.user-info) username;
  inherit (config.home.user-info) email;
in
{
  home.packages = with pkgs; [
    pass
    pass-secret-service
    bitwarden
    bitwarden-cli
    rbw
    pinentry-curses
  ];
  # Himalaya mail client
  # package: Himalaya
  # For nvim: vimPlugins.himalaya-vim
  accounts.email.accounts.${username} = {
    name = "Perso";
    userName = email;
    address = email;
    primary = true;
    realName = "Baptiste Grenier";
    signature =  {
      showsignature = "";
      text = "Baptiste Grenier";
    };
    # passwordCommand = "secret-tool lookup email me@example.org";
    imap = {
      host = "mail.bapt.name";
      port = 993;
      flavor = "plain";
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
    msmtp = {
      enable = false;
    };
    maildir = {
      enable = false;
      # path = "\${name}"
    };
    mbsync = {
      enable = false;
      create = "both";
      # path = "\${name}"
    };
    neomutt = {
      enable = true;
    };
    himalaya = {
      enable = true;
      # backend = "maildir";
      # backend = "imap";
      # sender = "smtp";
      # sender = "sendmail";
      # settings = {};
    };
  };
}
