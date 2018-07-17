#! /bin/sh

compton --config ~/.compton.conf&

(xset +fp /usr/share/fonts/terminus; xrdb -merge ~/.Xresources; xscreensaver -no-splash && xscreensaver-command -lock)&

#xbindkeys&
(setxkbmap dvorak; xmodmap ~/conf/misc/xmodmap.laptop.dvorak)&
#feh --bg-scale ~/docs/wallpapers/firefly.jpg
#feh --bg-fill ~/docs/wallpapers/iss/cas-blue-dot.jpg&
feh --bg-scale ~/docs/wallpapers/nasa-poster-vision-future/1*&
#feh --bg-fill ~/docs/wallpapers/iss/saturn1.jpg&
#klipper&
qlipper&
xscreensaver-command -lock&
conky&
dunst -config ~/.dunstrc&
xset b 0 0 0&
xset r rate 400 30&
unclutter -idle 30&
## while true; do
## 	if pgrep xscreensaver; then
## 		xscreensaver-command -lock&
## 		break;
## 	fi;
## 	sleep 0.5;
## done
