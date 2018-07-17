#! /bin/sh

ergo_id=$(xinput list | sed -nre 's/.*Ergo.*id=([0-9]+).*pointer.*/\1/p' | tail -n 1)
echo ergo: $ergo_id

notify-send Keyboard: $ergo_id

xset b 0 0 0
xset r rate 400 30


if [ -z $ergo_id ]; then
  echo NOT ERGO
  notify-send keyboard: laptop
  setxkbmap dvorak;
  xmodmap ~/conf/misc/xmodmap.laptop.dvorak
  exit 0
fi

notify-send keyboard: ergo
echo xinput set-prop $ergo_id 'Device Enabled' 0
xinput set-prop $ergo_id 'Device Enabled' 0
xmodmap ~/conf/misc/xmodmap.ergo.dvorak
