#! /bin/sh

compton --config ~/.compton.conf&
xset +fp /usr/share/fonts/terminus&
xrdb -merge ~/.Xresources&
#xbindkeys&
setxkbmap dvorak&
xmodmap ~/conf/misc/xmodmap.laptop.dvorak&
#feh --bg-scale ~/docs/wallpapers/firefly.jpg
#feh --bg-fill ~/docs/wallpapers/firefly.jpg&
feh --bg-scale ~/docs/wallpapers/iss/scand.jpg&
#klipper&
#qlipper&
(xscreensaver -no-splash && xscreensaver-command -lock&)
#while true; do
#	if pgrep xscreensaver; then
#		xscreensaver-command -lock&
#		break;
#	fi;
#	sleep 0.5;
#done
