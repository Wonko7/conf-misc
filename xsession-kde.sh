#! /bin/sh

# one shot:
feh --bg-scale ~/docs/wallpapers/nasa-poster-vision-future/1*&
~/conf/misc/scripts/kbd.sh&

# services:
(compton --config ~/.compton.conf&)
(xscreensaver -no-splash && xscreensaver-command -lock&)
(conky&)
(dunst -config ~/.dunstrc 2>&1 > /home/wjc/dunst.logs&)
(unclutter -idle 30&)
(qlipper&)
(lxqt-panel&)
