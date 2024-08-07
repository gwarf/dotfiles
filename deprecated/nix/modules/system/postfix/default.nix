{lib, pkgs, config, ...}:
{
  # Run a local postfix using google SMTP as a relay
  services.postfix = {
      enable = true;
    };
    relayHost = "smtp.gmail.com";
    relayPort = "587";
    # mapFiles = {};
    # extracConfig = '''';
    #inet_interfaces = loopback-only
    # 25 MB for GSMTP
    # message_size_limit = 26214400
    # mailbox_size_limit = 0
    # biff = no
    # mynetworks = 127.0.0.0/8, [::1]/128
    # smtpd_client_restrictions = permit_mynetworks permit_sasl_authenticated permit
    # relayhost = [smtp.gmail.com]:587
    # smtp_use_tls = yes
    # smtpd_sasl_auth_enable = yes
    # smtp_sasl_auth_enable = yes
    # smtp_sasl_password_maps = hash:/etc/postfix/sasl_passwd
    # smtp_use_tls=yes
    # smtp_tls_security_level=encrypt
    # tls_random_source=dev:/dev/urandom
    # smtp_sasl_security_options =
    # smtp_sasl_mechanism_filter = AUTH LOGIN
    # inet_protocols = ipv4
    # virtual_alias_maps = hash:/etc/postfix/virtual
}
