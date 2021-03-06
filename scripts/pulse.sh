#!/bin/bash

oldvolume=$(pacmd dump|grep set-sink-volume|grep alsa |cut -f3 -d' ')
pacmd dump | grep set-sink-mute | grep alsa | grep yes > /dev/null
oldmute=$?
case $1 in

	increase)
		newvolume=$(($oldvolume + 0x400))
		if (($newvolume >0x10000)) ; then
			newvolume=$((0x10000))
		fi
		pacmd set-sink-volume 0 $(printf '0x%x' $((newvolume)) ) 
		;;

	decrease)
		newvolume=$(($oldvolume - 0x400))
		if (($newvolume < 0 )) ; then
			newvolume=$((0x0000))
		fi
		pacmd set-sink-volume 0 $(printf '0x%x' $((newvolume)) ) 
		;;

	mute)
		if [[(($oldmute == 0))]] ; then
			pacmd set-sink-mute 0 0
		else
			pacmd set-sink-mute 0 1
		fi
		;;
	*)
		echo "usage pavolume increase | decrease | mute"
esac
