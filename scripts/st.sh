#! /bin/sh

HOST=$(hostname)

case $HOST in
  enterprise|rocinante)
    small_size=16
    big_size=16
    ;;
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
# desktop=$(wmctrl -d | sed -nre 's/.*\*.*\s+([0-9]+)$/\1/p')

if [ "$1" = "--small" ]; then
  size=$small_size
  shift
else
  size=$big_size
fi

#(st -f "FiraCode Nerd Font Mono:style=SemiBold,Regular:pixelsize=$size" $@)&
#(st -f "Hasklug Nerd Font Mono,Hasklig Semibold:style=Semibold:pixelsize=$size" $@)&
#(st -f "FuraMono Nerd Font:style=regular:pixelsize=$size" $@)&
#(st -f "Fira Mono,Fira Mono Medium:style=Medium,Regular:pixelsize=$size" $@)&
(st -f "JetBrainsMono Nerd Font Mono:style=Medium,Regular:pixelsize=$size" $@)&
