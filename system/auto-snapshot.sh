#! /bin/sh

MAX=10
prefix=AUTOSNAP

echo () {
	logger -t $prefix $*
}


mount /dev/sda4 /mnt/gentoo
cd /mnt/gentoo

for mountpoint in root home; do
	count=0
	for i in `ls _auto/$mountpoint-* -d | sort -r`; do
		count=$(( $count + 1 ))
		if [ $count -le $MAX ]; then
			echo Keeping $i
			continue
		fi

		btrfs subvolume delete -c $i
		echo Deleted $i
	done

	date=$(date "+%F")
	if [ ! -e _auto/$mountpoint-$date ]; then
		btrfs subvolume snapshot _live/$mountpoint _auto/$mountpoint-$date
		echo Created snapshot $mountpoint-$date
	fi
done

umount /mnt/gentoo
