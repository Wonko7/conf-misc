#! /bin/sh

HOST=$(hostname)

case $HOST in
  yggdrasill)
    small_size=15
    big_size=35
    ;;
  daban-urnud)
    small_size=20
    big_size=20
    ;;
  *)
    echo "unknown $HOST, guessing"
    small_size=20
    big_size=20
esac

# get current desktop nawe, which in my case is a [0-9]+:
desktop=$(wmctrl -d | sed -nre 's/.*\*.*\s+([0-9]+)$/\1/p')

if [ "$desktop" -lt 10 ]; then
  size=$big_size
else
  size=$small_size
fi

(st -f "Fira Mono for Powerline:pixelsize=$size" $@)&
