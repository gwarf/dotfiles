# Post install tasks on debian

## Chezmoi

No Debian package: https://github.com/twpayne/chezmoi/issues/2130

```shell
sudo apt install snapd
sudo snap install snapd
sudo snap install chezmoi --classic
sudo apt install git
export PATH="$PATH:/snap/bin"
chezmoi init git@github.com:gwarf/dotfiles.git
```

To do:
- Import GPG key + set it up
- Install git-delta from testing
	- https://tracker.debian.org/pkg/git-delta
