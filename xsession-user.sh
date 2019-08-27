#! /bin/sh

HOST=$(hostname)

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus-exports.sh
chmod a+r /tmp/dbus-exports.sh

# one shot:
#feh --bg-scale ~/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
case $HOST in
  yggdrasill)  feh --bg-scale ~/pics/dualspidey/t3.png&;;
  daban-urnud) feh --bg-scale /home/wjc/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png&;;
  *)           logger -s -p user.error "xsession-user: unknown $HOST no background!";;
esac

~/conf/misc/scripts/kbd.sh&
mute&

# services:
(xscreensaver -no-splash&)&
(conky -c ~/conf/misc/generated/$HOST.conkyrc &)&
# ... let me explain:
# conky needs to be restarted otherwise desktop names are all null. Then, if screen is locked before conky is restarted, conky crashes.
(sleep 1 && killall -s USR1 conky && sleep 3 && xscreensaver-command --lock)&
(compton --config ~/.compton.conf&)&
(python3.7 ~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock&)&
(dunst -config ~/conf/misc/generated/$HOST.dunstrc 2>&1 > /home/wjc/dunst.logs&)&
(unclutter -idle 30&)&
(qlipper&)&
(sleep 5 && ~/conf/misc/scripts/kbd.sh LOL1)&
(sleep 10 && ~/conf/misc/scripts/kbd.sh LOL2)&
(sleep 15 && ~/conf/misc/scripts/kbd.sh LOL3)&
(sleep 20 && ~/conf/misc/scripts/kbd.sh LOL4)&
#(lxqt-panel&) # fuck systemd which ignores its own KillUserProcesses=yes :(
