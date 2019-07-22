#! /bin/sh

HOST=$(hostname)

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus-exports.sh
chmod a+r /tmp/dbus-exports.sh

# one shot:
#feh --bg-scale ~/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
if [ $HOST = yggdrasill ]; then
  feh --bg-scale ~/pics/dualspidey/t3.png
else
  # daban-urnud
  feh --bg-scale /home/wjc/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
fi

~/conf/misc/scripts/kbd.sh&
mute

# services:
(compton --config ~/.compton.conf&)
(xscreensaver -no-splash && xscreensaver-command -lock&)
(python3.7 ~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock&)
(conky -c ~/conf/misc/conky/$HOST.conkyrc &)
(sleep 1 && killall -s USR1 conky&)
(dunst -config ~/.dunstrc 2>&1 > /home/wjc/dunst.logs&)
(unclutter -idle 30&)
(qlipper&)
#(lxqt-panel&) # fuck systemd which ignores its own KillUserProcesses=yes :(
