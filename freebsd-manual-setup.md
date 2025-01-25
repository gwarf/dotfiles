# FreeBSD manual setup

## pkgs

See [https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro](pkgng intro).

Use latest packages, to be used with HEAD of ports repository.

```shell
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "pkg+https://pkg.freebsd.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update -f
pkg upgrade -f
```

## Xorg

```shell
# Setup for using Xorg
doas pkg install drm-kmod xorg xf86-video-amdgpu gnome-lite gdm chromium
doas pw groupmod video -m baptiste
doas sysrc kld_list+="amdgpu"
doas kldload amdgpu
# For the mouse management
doas sh -c 'echo "kern.evdev.rcpt_mask=6" >> /etc/sysctl.conf'
```

```shell
# If willing to get info about hardware
doas pkg install clover
doas pkg install clinfo
clinfo
```

### Install fonts

```shell
doas pkg install uwrfonts google-fonts nerd-fonts
# XXX: required?
xset fp+ /usr/local/share/fonts/urwfonts
xset fp rehash
fc-cache -f
```

#### Search for a font/icon

https://www.nerdfonts.com/cheat-sheet

## Install Gnome desktop environment

Check [FreeBSD handbook](https://docs.freebsd.org/en/books/handbook/desktop/).

```shell
# Mount /proc
doas 'echo "proc			/proc	procfs	rw 		0	0" > /etc/fstab'
# Enable dbus service
doas sysrc dbus_enable="YES"
doas service dbus start
# Enable gdm service
doas sysrc gdm_enable="YES"
doas service gdm start
```

## Bootstrap chezmoi dependencies

### doas

```shell
pkg install doas
cp /usr/local/etc/doas.conf.sample /usr/local/etc/doas.conf
vi /usr/local/etc/doas.conf
```

## rbw

There is currently no official port for Obsidian. It's convenient to build it
using poudriere.

```shell
# Add rbw to the custom repository package list
doas echo "security/rbw> /usr/local/etc/poudriere.d/custom-pkglist
# Build custom packages using poudriere
doas poudriere bulk -f /usr/local/etc/poudriere.d/custom-pkglist -j 14-1-amd64 -p main -v -v
# Add repos definition
doas mkdir -p /usr/local/etc/pkg/repos/
doas vim /usr/local/etc/pkg/repos/custom.conf
Custom: {
  url: "file:///poudriere/data/packages/14-1-amd64-main"
}
doas pkg update
pkg search -Q repository rbw
daos pkg install rbw

## Install chezmoi

> Requirement to be able to access Bitwarden secrets: rbw and pinentry

```shell
scp ptidoux:/poudriere/data/packages/14-2-amd64-main/All/rbw-1.12.1_1.pkg .
doas pkg install rbw-1.12.1_1.pkg pinentry-gnome
```

[chezmoi](https://www.chezmoi.io/) will ake of installing all packages, but
system level configuration is to be done manually.
..
```shell
doas pkg install -y git chezmoi
chezmoi init gwarf
chezmoi apply
# Link repos to my usual place
mkdir -p ~/code/repos/
ln -s ~/.local/share/chezmoi ~/code/repos/dotfiles/
```

## Firefox setup

### Firefox sync

### Firefox extensions

Mimimal list of extensions to install:

- Bitwarden
- LanguageTool
- Privacy Badger
- uBlock Origin

### Fido in firefox

https://forums.freebsd.org/threads/firefox-61-u2f-fido-does-not-work.66989/
https://gist.github.com/daemonhorn/bdd77a7bc0ff5842e5a31d999b96e1f1

```shell
doas pw group mod u2f -m baptiste
doas sysrc devd_enable="YES"
doas service devd restart
```

## Mail

```shell
# Get password from Bitwarden add add it to local keyring
secret-tool store --label=mail host MAIL_SERVER service imaps user MAIL_USER
# Get mails
mkdir -p ~/Mail/Perso
#XXX: run mbsync manually and on demand
mbsync -a
mutt
```

## Poudriere setup to build ports locally

See https://blog.bapt.name/2024/08/31/building-freebsd-ports/.

## Obsidian

There is [port for Obsidian](https://www.freshports.org/textproc/obsidian/),

but due to licences issues it connot be redistributed. It's convenient to
build it using poudriere.

The build will be done using a set named `obsidian`, in order to allow to
configure make only for this package.

```shell
# Add obisidian to the package list
doas echo "textproc/obsidian" > /usr/local/etc/poudriere.d/obsidian-pkglist
doas echo "DISABLE_LICENSES=yes" > /usr/local/etc/poudriere.d/obsidian-make.conf
# Build obsidian using poudriere, and using the obsidian set
doas poudriere bulk -f /usr/local/etc/poudriere.d/obsidian-pkglist -j 14-1-amd64 -p main -z obsidian -v -v
# Add repos definition
doas mkdir -p /usr/local/etc/pkg/repos/
doas vim /usr/local/etc/pkg/repos/obsidian.conf
Obsidian: {
  url: "file:///poudriere/data/packages/14-1-amd64-main-obsidian"
}
doas pkg update
pkg search -Q repository obsidian
doas pkg install obsidian
```
```

## Keybase

https://wiki.freebsd.org/Ports/security/keybase
https://www.freshports.org/security/kbfsd (Not used?)
https://github.com/0mp/kbfsd

```shell
doas sysctl vfs.usermount=1
doas vim /etc/sysctl.conf
vfs.usermount=1
# Be in operator group
groups

doas kldload fusefs

doas vim /etc/rc.conf
kld_list="amdgpu ext2fs fusefs"

doas mkdir /keybase
doas chown baptiste:operator /keybase
chmod 770 /keybase/

kbfsfuse /keybase
ls /keybase/
```

## TODO

For nvim:
- package/install marksman
- package/insall ltex-ls 
- package/install markdownlint-cli2
