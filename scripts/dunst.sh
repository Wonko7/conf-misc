#! /bin/sh

dunst=$(xdotool search --name "^dunst$")

case $1 in
  close)     xdotool key --window $dunst ctrl+1;;
  close_all) xdotool key --window $dunst ctrl+2;;
  history)   xdotool key --window $dunst ctrl+3;;
esac
