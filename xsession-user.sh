#! /bin/sh

export DISPLAY=":0.0"
#export QT_QPA_PLATFORMTHEME="qt5ct" // env!
#export QT_AUTO_SCREEN_SCALE_FACTOR="1.5"

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus-exports.sh
chmod a+r /tmp/dbus-exports.sh

# one shot:
feh --bg-scale ~/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
~/conf/misc/scripts/kbd.sh&

# services:
(compton --config ~/.compton.conf&)
(xscreensaver -no-splash && xscreensaver-command -lock&)
(python3.7 ~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock&)
(conky&)
(sleep 1 && killall -s USR1 conky&)
(dunst -config ~/.dunstrc 2>&1 > /home/wjc/dunst.logs&)
(unclutter -idle 30&)
(qlipper&)
#(lxqt-panel&) # fuck systemd which ignores its own KillUserProcesses=yes :(
