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
