# pkgs

https://docs.freebsd.org/en/books/handbook/ports/#pkgng-intro

Use latest packages, to be used with HEAD of ports

```shell
mkdir -p /usr/local/etc/pkg/repos
echo 'FreeBSD: { url: "pkg+http://pkg.FreeBSD.org/${ABI}/latest" }' > /usr/local/etc/pkg/repos/FreeBSD.conf
pkg update -f
pkg upgrade
```

# doas

```shell
pkg install doas
cp /usr/local/etc/doas.conf.sampe /usr/local/etc/doas.conf
vim /usr/local/etc/doas.conf
```

# x11

```shell
pkg install xorg
pkg install xx86-video-amdgpu

pkg install clover
pkg install clinfo
clinfo

# XXX: broken?
# pkg install drm-kmod
pkg install drm-510-kmod
sysrc kld_list+="amdgpu"
```

## Install fonts

```shell
doas pkg install urwfonts google-fonts nerd-fonts
# XXX: required?
xset fp+ /usr/local/share/fonts/urwfonts
xset fp rehash
fc-cache -f
```

### Search for a font/icon

https://www.nerdfonts.com/cheat-sheet

# gnome

Follow handbook

```shell
pkg install xorg

# proc
# dbus
# gdm

```

# Mount ext4 FS

```shell
sysrc kld_list+="ext2fs"
gpart show
mkdir /mnt/data
mkdir /mnt/nix
ls /dev/ext2fs/
mount -r -t ext2fs /dev/nda0p9 /mnt/nix/
# If mount is not working, check dmesg
# If it says
# WARNING: mount of nda0p9 denied due to unsupported optional features:
# needs_recovery 
# It's required to clean fs using fsck.ext4
pkg instsall e2fsprogs
doas fsck.ext4 /dev/nda0p9
```

## Simplified mount

```shell
ls /dev/ext2fs/
root@brutal:~ # vim /etc/fstab 
/dev/ext2fs/nixos   /mnt/nix  ext2fs  rw,noauto       2       0
/dev/ext2fs/DataLinux   /mnt/data  ext2fs  rw,noauto       2       0

mount /mnt/nix
doas fsck.ext4 /dev/ext2fs/DataLinux 
mount /mnt/data
```

## Ports

https://docs.freebsd.org/en/books/handbook/ports/
https://docs.freebsd.org/en/books/handbook/ports/#ports-using
https://freebsdfoundation.org/resource/updating-freebsd-from-git/

Use HEAD of ports and use latest packages

```shell
doas pkg install git
doas git clone https://git.FreeBSD.org/ports.git /usr/ports
# Update
git -C /usr/ports pull
# Switch branch
# XXX: need a deep clone to be able to switch branches easily
git -C /usr/ports switch 2024Q3
```

# Obsidian

https://www.freshports.org/textproc/obsidian/

```shell
cd /usr/ports/textproc/obsidian/
root@brutal:/usr/ports/textproc/obsidian # head Makefile
pkg search electron
# XXX: is it needed?
# pkg install electron29
# XXX Not sure why, but do not seem to be working
# pkg install -A `make -V 'electron${ELECTRON_VERSION}'`
make USE_PACKAGE_DEPENDS_ONLY=yes install clean
```

# Tools

```shellc
pkg install vim neovim vlc firefox
```

# Chezmoi

```shell
doas pkg install chezmoi
https://github.com/$GITHUB_USERNAME/dotfiles.git
```

# TODO
For nvim:
- package/install marksman
- package/insall ltex-ls 
- package/install markdownlint-cli2

# Keybase

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
