#! /bin/sh

next=/mnt/next
stamp=$(date +%F)

function die {
    exit $1
}

function init {
    echo mounting /mnt/next

    if [ ! -d /mnt/gentoo/_live/next ]; then
        echo create?
        read ans
        [ "$ans" != y -a "$ans" != yes ] && die 5
        btrfs subvolume snapshot /mnt/gentoo/_live/root /mnt/gentoo/_live/next || die 5
        #sleep 0.5
        mount /dev/nvme0n1p4 /mnt/next -osubvol=_live/next || die 6
        sed -i /mnt/next/etc/os-release -re "s/^RELEASE_DATE=.*/RELEASE_DATE=\"init: $stamp\"/"
    else
        mount /dev/nvme0n1p4 /mnt/next -osubvol=_live/next
    fi

    mount --types proc /proc /mnt/next/proc
    mount --rbind /sys /mnt/next/sys
    mount --make-rslave /mnt/next/sys
    mount --rbind /dev /mnt/next/dev
    mount --make-rslave /mnt/next/dev
    mount --rbind /run /mnt/next/run

    mount /dev/nvme0n1p4 /mnt/next/home -osubvol=_live/home

    env -u HOME chroot --userspec wjc:wjc /mnt/next /bin/zsh
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
