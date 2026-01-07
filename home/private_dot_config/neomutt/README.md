# Requirements

- mutt (neomutt not supporting background edit as of 2022-11-28)
- Neovim ❤️ / vim
- mbsync (isync)
- msmtp / postfix
- Perl

## Accessing neomutt documentation

```shell
neomutt -O -Q smart_wrap
```

## Fetching emails / IMAP sync

mbsync from isync package.

## Sending emails

msmtp

## S/MIME signing

### On Mac OS X using gpgme (simplified configuration)

See <http://wiki.netbsd.org/users/wiz/mutt-smime/>

```shell
gpgsm --import TrustedRoot.crt
gpgsm --import DigiCertCA.crt
gpgsm --import baptiste_grenier_until_2021_02.p12
gpgsm --list-keys
```

### On Mac OS X using mutt/neomutt smime_keys feature

> Deprecated

Initialize S/MIME certificate store

```shell
$ /usr/local/Cellar/neomutt/20180716/libexec/neomutt/smime_keys init
# Import DigiCert root
$ /usr/local/Cellar/neomutt/20180716//libexec/neomutt/smime_keys add_root baptiste_grenier/TrustedRoot.crt
# Import certificate, key and DigiCert intermediate certificate
$ /usr/local/Cellar/neomutt/20180716/libexec/neomutt/smime_keys add_chain userkey.pem-new usercert.pem-new baptiste_grenier/DigiCertCA.crt
```

## Perl modules for Notmuch

It's possible to use [perlbrew](https://perlbrew.pl) to manage Perl modules.

```shell
# For querying mails using notmuch
$ cpanm Mail::Box::Maildir
$ cpanm String::ShellQuote
```

## Python setup for reading calendar invites

Requirements: pyhon3 + a virtual environment

```shell
# Get latest version at https://www.python.org/downloads/
$ pyenv install 3.11.2
$ pyenv local 3.11.2
$ python -m venv .venv
$ source .venv/bin/activate.fish
$ pip install -r requirements.txt
```

Mutt should be started with the appropriate python environment:

```shell
source ~/.config/neomutt/.venv/bin/activate.fish
mutt
```
