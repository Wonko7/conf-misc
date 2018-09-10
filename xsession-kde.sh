#! /bin/sh

export DISPLAY=":0.0"
export HOME=/home/wjc/
export XAUTHORITY=$HOME/.Xauthority
export QT_QPA_PLATFORMTHEME="qt5ct"
#export QT_AUTO_SCREEN_SCALE_FACTOR="1.5"

# one shot:
feh --bg-scale ~/docs/wallpapers/nasa-poster-vision-future/1*&
~/conf/misc/scripts/kbd.sh&
# services:
(compton --config ~/.compton.conf&)
(xscreensaver -no-splash && xscreensaver-command -lock&)
(~/conf/misc/systemd-lock-handler.py xscreensaver-command --lock&)
(conky && sleep 5 && killall -USR1 conky&) # still does not work. desktop number/name is broken.
(dunst -config ~/.dunstrc 2>&1 > /home/wjc/dunst.logs&)
(unclutter -idle 30&)
(qlipper&)
(lxqt-panel&)
