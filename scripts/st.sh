#! /bin/sh

if [ $HOST = yggdrasill ]; then
  small_size=15
  big_size=35
else
  # daban-urnud
  big_size=15
  small_size=15
fi


# get current desktop nawe, which in my case is a [0-9]+:
desktop=$(wmctrl -d | sed -nre 's/.*\*.*\s+([0-9]+)$/\1/p')

if [ "$desktop" -lt 10 ]; then
  size=35
else
  size=15
fi

st -f "Fira Mono for Powerline:pixelsize=$size" $@
