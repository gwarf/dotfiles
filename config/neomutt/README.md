# Requirements

* neomutt
* neovim / vim
* mbsync (isync)
* msmtp

## Fetching emails / IMAP sync

mbsync from isync package.

## Sending emails

msmtp

## S/MIME signing

### On Mac OS X

Initialize smime store

```sh
/usr/local/Cellar/neomutt/20180716/libexec/neomutt/smime_keys init
# Import DigiCert root
/usr/local/Cellar/neomutt/20180716//libexec/neomutt/smime_keys add_root baptiste_grenier/TrustedRoot.crt
# Import certificate, key and DigiCert intermediate certificate
/usr/local/Cellar/neomutt/20180716/libexec/neomutt/smime_keys add_chain userkey.pem-new usercert.pem-new baptiste_grenier/DigiCertCA.crt
```
