#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
    echo 'Script must be run as root!' 1>&2
    exit 1
fi

echo 'Fetching New mirrorlist from archlinux.org.'
curl https://www.archlinux.org/mirrorlist/all/ -o /etc/pacman.d/mirrorlist

echo 'Backing up mirrorlist.'
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

echo 'Enabling all mirrors.'
sed '/^#\S/ s|#||' -i /etc/pacman.d/mirrorlist.bak

echo 'Ranking enabled mirrors and selecting the 6 fastes. Will take time!'
rankmirrors -n 6 /etc/pacman.d/mirrorlist.bak > /etc/pacman.d/mirrorlist

echo 'Done. Please check /etc/pacman.d/mirrorlist for eventual errors.'
exit 0
