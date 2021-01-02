#! /bin/sh

MAX=10
prefix=AUTOSNAP

echo () {
  logger -t $prefix $*
}

cd /mnt/gentoo

for sub_vol in @home @work @data @root; do
  date=$(date "+%F")
  if [ ! -e "_auto/${sub_vol}-${date}" ]; then
    if [ ${sub_vol} -e "@root" ]; then
      btrfs subvolume snapshot _live/${sub_vol} _auto/${sub_vol}-${date}
    else
      btrfs subvolume snapshot -r _live/${sub_vol} _auto/${sub_vol}-${date}
    fi
    echo Created snapshot ${sub_vol}-${date}
  fi

  count=0
  for old_snapshot in `ls _auto/${sub_vol}-* -d 2> /dev/null | sort -r`; do
    count=$(( ${count} + 1 ))
    if [ ${count} -le ${MAX} ]; then
      echo Keeping $old_snapshot
      continue
    fi

    btrfs subvolume delete -c $old_snapshot
    echo Deleted $old_snapshot
  done

done
