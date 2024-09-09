## Mount external ZFS pool

```shell
# Show info about a ZFS label ln a partition
# Debian install
doas zdb -l /dev/ada0p3 # debian ZFS on root
doas zdb -l /dev/nda0p4 # main FreeBSD ZFS on root
daos zdb -l /dev/ada1p3.eli # geli encrytped FreeBSD system

# List pools, and their IDs
doas zpool import
# Import pool under /a
doas zpool import -fR /a POOL_ID
# Prompt for encryption key
doas zfs load-key -L prompt zroot
# Check available pools
doas zpool list
# Check available volumes
doas zfs list -r zrool
# Check key location
doas zfs get keylocation -r zroot
# Mount partitions
doas zfs mount zroot/ROOT/debian
doas zfs mount zroot/home

# Mount encrypted geli system
doas geli attach /dev/ada1p3
doas geli list
# Find proper pool ID in case there are duplicated names
doas zpool import
doas zpool import -fR /mnt POOL_ID

# Export the pool once no more used
doas zpool export zroot
```
