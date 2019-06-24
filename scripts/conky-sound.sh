#! /bin/sh

sound=($(pactl list sinks | sed -nre 's:^.*Volume.*front.* ([0-9]+)%.*:\1:p' -e 's/.*Mute: //p'))

if [ ! -z $1 ]; then
  echo '${color2}'${sound[1]}'%'
  if [ ${sound[0]} = 'on' ]; then
    echo '${color1}🖖🔊'
  else
    echo
    echo '${color1}🔇'
  fi
else
  echo ${sound[1]}
fi
