#! /bin/sh

ergo_id=$(xinput list | sed -nre 's/.*Ergo.*id=([0-9]+).*pointer.*/\1/p' | tail -n 1)

xset b 0 0 0
xset r rate 400 30


if [ -z $ergo_id ]; then
  notify-send keyboard: laptop
  setxkbmap dvorak;
  xmodmap ~/conf/misc/xmodmap.laptop.dvorak
  exit 0
fi

notify-send keyboard: ergo
xinput set-prop $ergo_id 'Device Enabled' 0
xmodmap ~/conf/misc/xmodmap.ergo.dvorak
