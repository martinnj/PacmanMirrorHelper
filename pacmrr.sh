#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo 'Script must be run as root!' 1>&2
    exit 1
fi

echo 'Backing up current mirrorlist.'
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.old

echo 'Fetching New mirrorlist from archlinux.org.'
curl https://www.archlinux.org/mirrorlist/all/ -o /etc/pacman.d/mirrorlist.new

echo 'Enabling all mirrors.'
sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist.new

echo 'Ranking enabled mirrors and selecting the 6 fastes. Will take time!'
rankmirrors -n 6 /etc/pacman.d/mirrorlist.new > /etc/pacman.d/mirrorlist

echo 'Removing temporary mirrorlist.'
rm /etc/pacman.d/mirrorlist.new

echo 'Done. Please check /etc/pacman.d/mirrorlist for eventual errors.'
exit 0
