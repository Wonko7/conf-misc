#! /bin/sh

HOST=$(hostname)
MAX=10
prefix=AUTOSNAP
date=$(date "+%F_%s")

echo () {
  logger -t $prefix $*
}

case $HOST in
  nostromo)
    VOLUMES="/mnt/gentoo /mnt/trantor"
    ;;
  yggdrasill|daban-urnud|rocinante)
    VOLUMES="/mnt/gentoo"
    ;;
  *)
    echo "Abort unknown host: $HOST"
    exit 1
esac


for vol in $VOLUMES; do
  for sub_vol in $(ls ${vol}/_live); do

    [ "$sub_vol" = "@swap" ] && continue

    if [ ! -e "${vol}/_auto/${sub_vol}-${date}" ]; then
      if [ ${sub_vol} = "@root" ]; then
        btrfs subvolume snapshot ${vol}/_live/${sub_vol} ${vol}/_auto/${sub_vol}-${date}
      else
        btrfs subvolume snapshot -r ${vol}/_live/${sub_vol} ${vol}/_auto/${sub_vol}-${date}
      fi
      echo Created snapshot ${vol}/_auto/${sub_vol}-${date}
    fi

    count=0
    for old_snapshot in $(ls ${vol}/_auto/${sub_vol}-* -d 2> /dev/null | sort -r); do
      count=$(( ${count} + 1 ))
      if [ ${count} -le ${MAX} ]; then
        echo Keeping $old_snapshot
        continue
      fi

      btrfs subvolume delete -c $old_snapshot
      echo Deleted $old_snapshot
    done
  done
done
