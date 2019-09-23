#! /bin/sh

source ~/conf/zsh/env.zsh

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus-exports.sh
chmod a+r /tmp/dbus-exports.sh
local sleepy_time=3

# one shot:
#feh --bg-scale ~/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
case $HOST in
  yggdrasill)
    feh --bg-scale ~/pics/dualspidey/t3.png&
    sleepy_time=4
    ;;
  daban-urnud)
    feh --bg-scale /home/wjc/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png&
    sleepy_time=5
    ;;
  *)
    logger -s -p user.error "xsession-user: unknown $HOST no background!";;
esac

~/conf/misc/scripts/kbd.sh&
mute&

# services:
(xscreensaver -no-splash&)&
(conky -c ~/conf/misc/generated/$HOST.conkyrc &)&
# ... let me explain:
# conky needs to be restarted otherwise desktop names are all null. Then, if screen is locked before conky is restarted, conky crashes.
(sleep 2 && killall -s USR1 conky)&
(compton --config ~/.compton.conf)&
(python3.7 ~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock)&
(dunst -config ~/conf/misc/generated/$HOST.dunstrc)&
(unclutter -idle 30&)&
(redshift -l $(pass show stuff/location-alpha))&
(qlipper&)&


# sigh:
(sleep 5 && ~/conf/misc/scripts/kbd.sh LOL1)&
(sleep 10 && ~/conf/misc/scripts/kbd.sh LOL2)&
(sleep 15 && ~/conf/misc/scripts/kbd.sh LOL3)&
(sleep 20 && ~/conf/misc/scripts/kbd.sh LOL4)&
