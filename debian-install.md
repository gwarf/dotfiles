# Debian setup notes

## ZFS on ROOT

Follow https://www.dwarmstrong.org/debian-install-zfs/.

```shell
echo brutal > /etc/hostname 
echo -e '127.0.1.1\tbrutal' >> /etc/hosts
vi /etc/hosts
ip addr
vi /etc/network/interfaces.d/enp5s0
allow-hotplug enp5s0
iface enp5s0 inet dhcp
vi /etc/apt/sources.list
apt install -y console-setup cryptsetup curl dosfstools efibootmgr keyboard-configuration locales sudo vim
apt install -y openssh-server
dpkg-reconfigure tzdata
dpkg-reconfigure locales
dpkg-reconfigure console-setup
setupcon
dpkg-reconfigure keyboard-configuration
passwd
adduser baptiste

echo $EFI_DISK
mkfs.vfat -F32 $EFI_DISK
echo "swap /dev/disk/by-partlabel/swap /dev/urandom swap,offset=2048,cipher=aes-xts-plain64,size=512" >> /etc/crypttab

cat << EOF > /etc/fstab
$( blkid | grep "$EFI_DISK" | cut -d ' ' -f 2 ) /boot/efi vfat defaults 0 0
/dev/mapper/swap none swap defaults 0 0
proc /proc proc defaults 0 0
EOF

vim /etc/fstab 
mkdir -p /boot/efi
mount /boot/efi
echo "REMAKE_INITRD=yes" > /etc/dkms/zfs.conf
apt update
apt install -y linux-headers-amd64 linux-image-amd64 zfs-initramfs dosfstools
echo "REMAKE_INITRD=yes" > /etc/dkms/zfs.conf
systemctl enable zfs.target
systemctl enable zfs-import-cache
systemctl enable zfs-mount
systemctl enable zfs-import.target
echo "UMASK=0077" > /etc/initramfs-tools/conf.d/umask.conf
update-initramfs -c -k all
zfs set org.zfsbootmenu:commandline="quiet loglevel=4" zroot/ROOT
zfs set org.zfsbootmenu:keysource="zroot/ROOT/${ID}" zroot
zpool set cachefile=/etc/zfs/zpool.cache zroot
mkdir -p /boot/efi/EFI/ZBM
curl -o /boot/efi/EFI/ZBM/VMLINUZ.EFI -L https://get.zfsbootmenu.org/efi
cp /boot/efi/EFI/ZBM/VMLINUZ.EFI /boot/efi/EFI/ZBM/VMLINUZ-BACKUP.EFI
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
efibootmgr -c -d "$EFI_DISK" -p "$EFI_PART" -L "ZFSBootMenu (Backup)" -l '\EFI\ZBM\VMLINUZ-BACKUP.EFI'
efibootmgr -c -d "$EFI_DISK" -p "$EFI_PART" -L "ZFSBootMenu" -l '\EFI\ZBM\VMLINUZ.EFI'
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
ls /sys/firmware/
modprobe efivarfs
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
cat /sys/firmware/efi/fw_platform_size
mount /boot/efi
ls /boot/efi/
ls /boot/efi/EFI/
ls /boot/efi/EFI/ZBM/
mount -t efivarfs efivarfs /sys/firmware/efi/efivars
efibootmgr -c -d "$EFI_DISK" -p "$EFI_PART" -L "ZFSBootMenu (Backup)" -l '\EFI\ZBM\VMLINUZ-BACKUP.EFI'
efibootmgr -c -d "$EFI_DISK" -p "$EFI_PART" -L "ZFSBootMenu" -l '\EFI\ZBM\VMLINUZ.EFI'
exit
vim /etc/group
sudo:x:27:baptiste
visudo
%sudo   ALL=(ALL:ALL) ALL
```

## Post install tasks on debian

### Switch to debian testing

Need to use testing to get some more recent software, like for
[delta](https://tracker.debian.org/pkg/git-delta).

```shell
sudo apt update && sudo apt full-upgrade

sudo nvim /etc/apt/sources.list
deb http://deb.debian.org/debian/ testing main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ testing main contrib non-free non-free-firmware

deb http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware
deb-src http://security.debian.org/debian-security testing-security main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ testing-updates main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ testing-updates main contrib non-free non-free-firmware

deb http://deb.debian.org/debian/ testing-backports main contrib non-free non-free-firmware
deb-src http://deb.debian.org/debian/ testing-backports main contrib non-free non-free-firmware

sudo vim /etc/apt/apt.conf
APT::Default-Release "testing";
APT::Install-Recommends "false";
APT::Install-Suggests "false";

sudo vim /etc/apt/apt.conf.d/disable-recommends
APT::Install-Recommends "false";
APT::Install-Suggests "false";

sudo apt update && sudo apt full-upgrade
```

### Install gnome desktop environment

```shell
sudo apt install gnome/stable
sudo apt install gdm3
sudo apt install xorg mesa-utils x11-xfs-utils firmware-amd-graphics firmware-misc-nonfree
sudo apt install fonts-symbola fonts-font-awesome fonts-material-design-icons-iconfont
sudo systemctl start gdm3
```

### Fish shell setup

```shell
sudo apt install fish
curl -sS https://starship.rs/install.sh | sh
chsh -s /usr/bin/fish
```

### Install keybase to import GPG key and set GPG configuration up

```shell
curl --remote-name https://prerelease.keybase.io/keybase_amd64.deb
sudo apt install ./keybase_amd64.deb
cat /etc/apt/sources.list.d/keybase.list
### THIS FILE IS AUTOMATICALLY CONFIGURED ###
# You may comment out this entry, but any other modifications may be lost.
deb http://prerelease.keybase.io/deb stable main
keybase
```

### Set GPG configuration up

```shell
# Retrieve and them import GPG key
gpg --allow-secret-key --import xxxx.asc
```

### Install snpad

```shell
sudo apt install snapd
sudo snap install snapd
```

### Install additionnal software using snap

> XXX: move to [packages.yml](home/.chezmoidata/packages.yaml),
finding a way to pass parameters.

```shell
snap install nvim --classic
sudo snap install --edge prettier
sudo snap install --edge starship
sudo snap install obsidian --classic
```

### Deploy user dotfiles using Chezmoi

> No Debian package: https://github.com/twpayne/chezmoi/issues/2130

```shell
sudo snap install chezmoi --classic
sudo apt install git
export PATH="$PATH:/snap/bin"
chezmoi init git@github.com:gwarf/dotfiles.git
```

### Install nerd fonts

```shell
~/bin/nerd-fonts.sh
```
