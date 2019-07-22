#! /bin/sh

HOST=$(hostname)

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus-exports.sh
chmod a+r /tmp/dbus-exports.sh

# one shot:
#feh --bg-scale ~/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
case $HOST in
  yggdrasill)  feh --bg-scale ~/pics/dualspidey/t3.png;;
  daban-urnud) feh --bg-scale /home/wjc/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png;;
  *)           logger -s -p user.error "xsession-user: unknown $HOST no background!";;
esac

~/conf/misc/scripts/kbd.sh&
mute

# services:
(compton --config ~/.compton.conf&)
(xscreensaver -no-splash && xscreensaver-command -lock&)
(python3.7 ~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock&)
(conky -c ~/conf/misc/generated/$HOST.conkyrc &)
(sleep 1 && killall -s USR1 conky&)
(dunst -config ~/conf/misc/generated/$HOST.dunstrc 2>&1 > /home/wjc/dunst.logs&)
(unclutter -idle 30&)
(qlipper&)
#(lxqt-panel&) # fuck systemd which ignores its own KillUserProcesses=yes :(
