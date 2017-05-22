#! /bin/sh

compton --config ~/.compton.conf&

(xset +fp /usr/share/fonts/terminus; xrdb -merge ~/.Xresources; xscreensaver -no-splash&)
#xbindkeys&
(setxkbmap dvorak; xmodmap ~/conf/misc/xmodmap.laptop.dvorak)&
#feh --bg-scale ~/docs/wallpapers/firefly.jpg
#feh --bg-fill ~/docs/wallpapers/firefly.jpg&
feh --bg-fill ~/docs/wallpapers/iss/saturn1.jpg&
#klipper&
#qlipper&
#xscreensaver-command -lock&
dunst -config ~/.dunstrc&
xset b 0 0 0&
xset r rate 400 30&
unclutter -idle 1&
while true; do
	if pgrep xscreensaver; then
		xscreensaver-command -lock&
		break;
	fi;
	sleep 0.5;
done
