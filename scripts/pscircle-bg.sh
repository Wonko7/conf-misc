#!/usr/bin/env bash

#$nb_screens=`xrandr | grep " connected" | wc -l`

#bg_in=/data/docs/pics/wallpapers/spacex2/Space-X-falcon-heavy-space-rocket-Quad-HD-wallpapers-2.jpg&
bg_in="/data/docs/pics/wallpapers/nasa-poster-vision-future/1 - 8XMgqaI.png"
bg_out=/tmp/.${USER}-wallpaper/w.png
dir=/tmp/.${USER}-wallpaper
mkdir -p $dir

# convert -resize 1366x768 .wall/Crowl.png .pscircle.png

TIME_INTERVAL=3 # Seconds

while [ 1 ]; do
    # Replace the next line with any parameters given in the examples.
      # #4120 x 2318
    pscircle \
      --output-width=4120 \
      --output-height=2318 \
      --background-image="$bg_in" \
      --link-color-min=444444 \
      --link-color-max=375143 \
      --dot-color-min=b4b6e4 \
      --dot-color-max=ffa2b1 \
      --tree-font-color=87d2ff \
      --toplists-font-color=C8D2D7 \
      --toplists-pid-font-color=7B9098 \
      --toplists-bar-background=444444 \
      --toplists-bar-color=87d2ff \
      --max-children=55 \
      --tree-radius-increment=250 \
      --dot-radius=9 \
      --link-width=1.3 \
      --tree-font-face="JetBrainsMono Nerd Font Mono" \
      --toplists-font-face="JetBrainsMono Nerd Font Mono" \
      --tree-font-size=33 \
      --toplists-font-size=35 \
      --toplists-bar-width=90 \
      --toplists-row-height=45 \
      --toplists-bar-height=9 \
      --toplists-column-padding=45 \
      --cpulist-center=1300.0:-300.0 \
      --memlist-center=1300.0:200.0 \
      --interval=0 \
      --output=$bg_out

    feh --bg-scale $bg_out
    sleep $TIME_INTERVAL
done
