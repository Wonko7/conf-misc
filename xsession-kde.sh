#!/bin/bash

conky&
compton --config ~/.compton.conf&
xbindkeys&
(setxkbmap dvorak; xmodmap ~/conf/misc/xmodmap.laptop.dvorak&)&
