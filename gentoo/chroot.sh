#! /bin/sh

next=/mnt/next
stamp=$(date +%F)

function die {
    if [ ! -z "$1" ] ; then
        exit $1
    else
        exit 1
    fi
}

function init {
    echo mounting /mnt/next

    if [ ! -d /mnt/gentoo/_live/next ]; then
        echo create?
        read ans
        [ "$ans" != y && "$ans" != yes ] && die 5
        btrfs subvolume snapshot /mnt/gentoo/_live/root /mnt/gentoo/_live/next
        mount /dev/nvme0n1p4 /mnt/next -osubvol=_live/next
        sed -i /mnt/next/etc/os-release -re "s/^RELEASE_DATE=.*/RELEASE_DATE=\"init: $stamp\"/"
    else
        mount /dev/nvme0n1p4 /mnt/next -osubvol=_live/next
    fi

    mount --types proc /proc /mnt/gentoo/proc
    mount --rbind /sys /mnt/gentoo/sys
    mount --make-rslave /mnt/gentoo/sys
    mount --rbind /dev /mnt/gentoo/dev
    mount --make-rslave /mnt/gentoo/dev
    mount --rbind /run /mnt/gentoo/run

    mount /dev/nvme0n1p4 /mnt/gentoo/home -osubvol=_live/home

    env -u HOME chroot --userspec wjc:wjc /mnt/gentoo /bin/zsh
}

function finalize {
    if [ ! -d /mnt/gentoo/_live/next ]; then
        die 33
    fi

    sed -i /mnt/next/etc/os-release -re "s/^(RELEASE_DATE=.*)\"/\1 release: $stamp\"/"
    
    mv /mnt/gentoo/_live/root /mnt/gentoo/_old/root-$stamp
    mv /mnt/gentoo/_live/next /mnt/gentoo/_live/root
}

$@
