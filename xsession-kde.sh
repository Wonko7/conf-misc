#! /bin/sh

compton --config ~/.compton.conf&
xbindkeys&
(setxkbmap dvorak; xmodmap ~/conf/misc/xmodmap.laptop.dvorak&)&
#(conky 2>&1 >> ~/conky.log &)&
#conky >> ~/conky.log

