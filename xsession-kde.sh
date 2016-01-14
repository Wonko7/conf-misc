#!/bin/bash

compton --config ~/.compton.conf&
xbindkeys&
(setxkbmap dvorak; xmodmap ~/conf/misc/xmodmap.laptop.dvorak&)&
(conky&)
