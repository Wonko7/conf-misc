#!/bin/bash

if [ -z $DISPLAY ]; then
	export DISPLAY=":0" 
fi

export DISPLAY=":0" 

usermodmap=/home/$USER/.Xmodmap

if [ -f "$usermodmap" ]; then
    xmodmap -display "$DISPLAY" "$usermodmap"&
fi

xset b 0 0 0&
xset r rate 400 50&
