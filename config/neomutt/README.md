# Requirements

- neomutt
- neovim / vim
- mbsync (isync)
- msmtp

## Fetching emails / IMAP sync

mbsync from isync package.

## Sending emails

msmtp

## S/MIME signing

### On Mac OS X using gpgme (simplified conf)

See http://wiki.netbsd.org/users/wiz/mutt-smime/

```sh
gpgsm --import TrustedRoot.crt
gpgsm --import DigiCertCA.crt
gpgsm --import baptiste_grenier_until_2021_02.p12
gpgsm --list-keys
```

### On Mac OS X using mutt/neomutt smime_keyes feature

Initialize smime store

```sh
/usr/local/Cellar/neomutt/20180716/libexec/neomutt/smime_keys init
# Import DigiCert root
/usr/local/Cellar/neomutt/20180716//libexec/neomutt/smime_keys add_root baptiste_grenier/TrustedRoot.crt
# Import certificate, key and DigiCert intermediate certificate
/usr/local/Cellar/neomutt/20180716/libexec/neomutt/smime_keys add_chain userkey.pem-new usercert.pem-new baptiste_grenier/DigiCertCA.crt
```
