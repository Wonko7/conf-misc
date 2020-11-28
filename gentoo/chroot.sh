#! /bin/sh

HOST=`hostname`
case $HOST in
    yggdrasill)
        root_name=gentoo-root
        home_name=gentoo-home
        device=/dev/nvme0n1p4
    ;;
    rocinante)
        root_name=root
        home_name=home
        device=/dev/nvme0n1p4
    ;;
    *)
        echo missing config for $HOST
        exit 1
esac

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
        btrfs subvolume snapshot /mnt/gentoo/_live/$root_name /mnt/gentoo/_live/next || die 5
        mount $device /mnt/next -osubvol=_live/next || die 6
        sed -i /mnt/next/etc/os-release -re "s/^RELEASE_DATE=.*/RELEASE_DATE=\"init: $stamp\"/" # FIXME create too.
    else
        mount $device /mnt/next -osubvol=_live/next || echo "something is already mounted on next, pretending that's ok"
    fi

    mount --types proc /proc /mnt/next/proc
    mount --rbind /sys /mnt/next/sys
    mount --make-rslave /mnt/next/sys
    mount --rbind /dev /mnt/next/dev
    mount --make-rslave /mnt/next/dev
    mount --rbind /run /mnt/next/run

    mount $device /mnt/next/home -osubvol=_live/$home_name

    env -u HOME chroot --userspec wjc:wjc /mnt/next /bin/zsh
}

function finalize {
    if [ ! -d /mnt/gentoo/_live/next ]; then
        die 33
    fi

    sed -i /mnt/next/etc/os-release -re "s/^(RELEASE_DATE=.*)\"/\1 release: $stamp\"/"
    
    mv /mnt/gentoo/_live/$root_name /mnt/gentoo/_old/${root_name}_${stamp}
    mv /mnt/gentoo/_live/next /mnt/gentoo/_live/$root_name
}

$@
