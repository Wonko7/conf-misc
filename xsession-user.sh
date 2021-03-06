#! /bin/sh

source ~/conf/zsh/env.zsh
#source ~/conf/zsh/alias.zsh

echo "export DBUS_SESSION_BUS_ADDRESS=$DBUS_SESSION_BUS_ADDRESS" > /tmp/dbus-exports.sh
chmod a+r /tmp/dbus-exports.sh
sleepy_time=3

# one shot:
#feh --bg-scale ~/pics/spideyverse-vlcsnap-2019-03-23-17h34m19s903.png
case $HOST in
  yggdrasill-dual-screen)
    feh --bg-scale ~/pics/dualspidey/t3.png&
    sleepy_time=4
    ;;
  enterprise|yggdrasill|daban-urnud|rocinante)
    feh --bg-fill /data/docs/pics/wallpapers/spacex2/Space-X-falcon-heavy-space-rocket-Quad-HD-wallpapers-2.jpg&
    ;;
  *)
    logger -s -p user.error "xsession-user: unknown $HOST no background!";;
esac

~/conf/misc/scripts/kbd.sh&
#mute

# services:
if which s6-svscan > /dev/null 2> /dev/null; then
  (s6-svscan ~/conf/s6-services&)
else
  (xscreensaver -no-splash&)
  (conky -c ~/conf/misc/generated/$HOST.conkyrc &)
  (picom --config ~/.compton.conf&)
  (python3.7 ~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock&)
  (dunst -config ~/conf/misc/generated/$HOST.dunstrc&)
  (notif notify $HOST&)
  (~/conf/misc/scripts/session-lock-actions.sh&)
  (unclutter -idle 30&)
  (redshift -l $(pass show stuff/location-alpha)&)
  (qlipper&)
fi

# ... let me explain:
# conky needs to be restarted otherwise desktop names are all null. Also, if screen is locked before conky is restarted, conky crashes.
(sleep 2 && killall -s USR1 conky || echo killall conky did not work)&

# sigh:
sleep 5 && ~/conf/misc/scripts/kbd.sh LOL1
sleep 5 && ~/conf/misc/scripts/kbd.sh LOL1
sleep 5 && ~/conf/misc/scripts/kbd.sh LOL1
sleep 5 && ~/conf/misc/scripts/kbd.sh LOL1
