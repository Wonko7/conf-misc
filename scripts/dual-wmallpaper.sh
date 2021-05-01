#!/bin/sh

#DISPLAY:=:1
image=$(realpath $1)
resolutions=$(xrandr | sed -nre '/ connected / { s/.* ([0-9]+x[0-9]+)\+.*/\1/p }')

work=$(mktemp -d)
n=$(basename $image);

for i in $resolutions; do

  echo convert $image -resize $i $work/i_$n
  convert $image -resize $i $work/i_$n
done

convert $work/*_$n +append $2
