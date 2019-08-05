#! /bin/sh

#sleep 1 # for udev events
export DISPLAY=":0.0"
export HOME=/home/wjc/
export XAUTHORITY=$HOME/.Xauthority
HOST=$(hostname)

# logs=/tmp/kbd/lol-$(date '+%s')
# echo $1 >> $logs

ergo_id=$(xinput list | sed -nre 's/.*Ergo.*id=([0-9]+).*pointer.*/\1/p')

xset b 0 0 0
xset r rate 400 30

if [ -z "$ergo_id" -o ! -z "$1" ]; then # --laptop
  setxkbmap dvorak
  xmodmap ~/conf/misc/xmodmap/$HOST.xmodmap
  xmodmap ~/conf/misc/xmodmap/common.xmodmap
  /home/wjc/conf/notify-user/notify-user.sh ":(" keyboard: laptop
  exit 0
fi

for id in $ergo_id; do
  echo $id
  xinput set-prop $id 'Device Enabled' 0
done
setxkbmap us
xmodmap ~/conf/misc/xmodmap/ergo.xmodmap
xmodmap ~/conf/misc/xmodmap/common.xmodmap
/home/wjc/conf/notify-user/notify-user.sh ":)" keyboard: ergo
