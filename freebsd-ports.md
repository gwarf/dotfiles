# Working as root

```shell
# Configure git commit info as root
doas git config --global user.name "Baptiste Grenier"
doas git config --global user.email "baptiste@bapt.name"

# Create a branch to work in
doas git branch rbw
doas git checkout rbw
doas git checkout -b rbw

# Do work to create or update the port

# Commit changes to the work branch
doas git status
doas git add .
doas git commit -am 'Bump rbw to 1.12.1'

# Create a patch
doas git format-patch origin/main

# Copy files to custom repo
cp /usr/ports/security/rbw/{distinfo,Makefile,pkg-desc,pkg-plist} /home/baptiste/repos/freebsd-ports-custom/security/rbw

# Switch back to main branch
doas git checkout main
doas git pull

# Rebase rbw work branch from main to get latest changes
doas git pull rebase origin/main rbw
```

# Working as a user

## Clone FreeBSD ports as a use

```shell
git clone https://git.FreeBSD.org/ports.git freebsd-ports
cd freebsd-ports
git co -b 'lua-resty-patches'
# Customise/bump makefile
# Update checksums
make makesum
# Fort ports with flavours
FLAVOR=3x make makesum
# Only if needed? It builds and install stuff apparently
doas make makeplist
```

https://people.freebsd.org/~olivierd/porters-handbook/testing-poudriere.html


## Clone custom ports repository

```shell
```

## Make a patch to send to bugzilla

```shell
cd ~/repos/freebsd-ports
# Update main branch
git checkout main
git pull
# Create a new branch
git checkout -b rbw
# Rebase the branch for main if it was already created
git rebase origin/main rbw
# Add changes from personal repo
cp -rv ~/repos/freebsd-ports-custom/security/rbw  ~/repos/freebsd-ports/security/ 
# Commit changes
git add security/rbw
git commit -am 'Add rbw port'
# Create a patch from origin
git format-patch origin/main
# Propose 0001-Add-rbw-port.patch via bugzilla
```
## Update using a PR in GitHub

# Build with poudriere

```shell	
doas pkg update
doas pkg install poudriere
```

```shell
# Find a suitable ZFS pool, here it will be zroot
zpool list

# Create dataset for poudriere
zfs create zroot/poudriere

# Set the moundpoint of the ZFS dataset for poudriere
zfs set mountpoint=/poudriere zroot/poudriere

pkg install poudriere git portshaker

vim /usr/local/etc/poudriere.conf
ZPOOL=zroot
ZROOTFS=/poudriere
FREEBSD_HOST=https://download.FreeBSD.org
RESOLV_CONF=/etc/resolv.conf
BASEFS=/poudriere/base
DISTFILES_CACHE=/usr/ports/distfiles
USE_PORTLINT=yes
USE_TMPFS=yes
NOLINUX=yes
ALLOW_MAKE_JOBS=yes
PACKAGE_FETCH_BRANCH=latest

# Create build jail
doas poudriere jail -c -j 14-1-amd64 -v 14.1-RELEASE

# Create a ports tree with default options
doas poudriere ports -c
# Check the ports tree that got created
poudriere ports -l
```

## Adding custom packages manually

```shell
doas cp -rv /home/baptiste/repos/freebsd-ports-custom/security/rbw /poudriere/base/ports/default/security/
```

## Building the packages

```shell
# Populate list of packages to be built
doas echo 'security/rbw' > /usr/local/etc/poudriere.d/pkglist
doas echo 'www/lua-resty-session' >> /usr/local/etc/poudriere.d/pkglist
# Build packages verbosely
doas poudriere bulk -f /usr/local/etc/poudriere.d/pkglist -j 14-1-amd64 -v -v -v
```

## Using portshaker

```shell
# Alternative: create empty port tree that will be filled by portshaker
doas poudriere ports -cF -p main

# Create a dedicated volume for portshaker cache
zfs create zroot/portshaker
zfs set mountpoint=/var/cache/portshaker zroot/portshaker

vim /usr/local/etc/portshaker.d/custom
#!/bin/sh
. /usr/local/share/portshaker/portshaker.subr
if [ "$1" != '--' ]; then
  err 1 "Extra arguments"
fi
shift
method="git"
# For a private repo
# git_clone_uri="git@github.com:gwarf/freebsd-ports-custom.git"
git_clone_uri="https://github.com/gwarf/freebsd-ports-custom.git"
git_branch="main"
run_portshaker_command "$@"
chmod +x /usr/local/etc/portshaker.d/custom

vim /usr/local/etc/portshaker.d/freebsd
#!/bin/sh
. /usr/local/share/portshaker/portshaker.subr
​if [ "$1" != '--' ]; then
  err 1 "Extra arguments"
fi
shift
method="git"
git_clone_uri="https://github.com/freebsd/freebsd-ports.git"
git_branch="main"
run_portshaker_command "$@"
chmod +x /usr/local/etc/portshaker.d/freebsd

vim /usr/local/etc/portshaker.conf
mirror_base_dir="/var/cache/portshaker"
ports_trees="main"
use_zfs="yes"
poudriere_dataset="zroot/poudriere"
poudriere_ports_mountpoint="/usr/local/poudriere/ports"
main_poudriere_tree="main"
# Force overwritting files freebsd ports with custom overlay
# This doesn't remove non matching files
main_merge_from="freebsd custom+"

# Update ports trees
portshaker -U
# Merge prot trees
porthakser -M
# Updat and merge port trees
portshaker
```

# Adding an updated package

```shell
# Work on updating the port/bumping version
# Make makesum in the main/host to be able to update the distinfo file
doas make makesum
# Copy new/updated ports to poudriere merged folder
doas cp -rv /poudriere/ports/main/www/lua-resty-session3 /poudriere/ports/main/www/
# Build the port
doas poudriere testport -j 14-1-amd64 -p main -i www/lua-resty-session3
# In the jail 
pwd
# Check plist and save it to /tmp as not allowed to write to the makefile
make makeplist > /tmp/$(make -V PORTNAME)-plist
doas vim -O /poudriere/data/.m/14-1-amd64-main/ref/tmp/lua-resty-session-plist /poudriere/data/.m/14-1-amd64-main/ref/usr/ports/www/lua-resty-session3/Makefile

```

```shell
# Add new port
cp -r ~/repos/freebsd-ports/security/lua-resty-openidc ~/repos/freebsd-ports-custom/security/

# test port in a jail
doas poudriere testport -j 14-1-amd64 -p main -o security/rbw
```

## Building the packages

```shell
# Populate list of packages to be built
doas echo 'security/rbw' > /usr/local/etc/poudriere.d/pkglist
doas echo 'www/lua-resty-session' >> /usr/local/etc/poudriere.d/pkglist
# Build packages verbosely
## Using main ports tree
doas poudriere bulk -f /usr/local/etc/poudriere.d/pkglist -j 14-1-amd64 -p main -v -v -v
```




# Update rbw version and send a new patch

```shell
cd ~/repos/freebsd-ports-custom/security/rbw
# Update version
vim Makefile

# Review and commit changes
git commit -am 'Update rbw to 1.12.1'
# Push changes remotely
git push
# Update and merge portshaker repositories
doas portshaker
# Test updated port, moving to interactive use to be able to update the Makefile
doas poudriere testport -j 14-1-amd64 -p main -o security/rbw -i
su -
# Update cargo crates
#FIXME: this reports issues
# Not validating first entry in CATEGORIES due to being outside of PORTSDIR.
make cargo-crates >> Makefile
# Merge cargo-crates update
vim Makefile
# Update sums
make makesum
#XXX: get changes from the jail to update the ports tree outside of the Jail

# Push changes to customised branch
cd ~/repos/freebsd-ports/security/rbw/
cp -rv ~/repos/freebsd-ports-custom/security/rbw/* .

# Commit changes to rbw branch or to a new branch
git fetch
git rebase origin/main rbw
# Squash changes if the updated port is not yet in the tree
git rebase -i ...
# Review changes
git diff origin/main
# Create a patch
git format-patch origin/main

# TODO: trying by passing path to local repo to poudriere using -O overlay
```


# Create patch for new lua-resty-session3


```shell
cp -rv ~/repos/freebsd-ports-custom/www/lua-resty-session3 www/
git add www/lua-resty-session3
git status
git ci -am 'www/lua-resty-session3 new port sticking to version 3'
```
