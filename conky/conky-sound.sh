#! /bin/sh

sound=($(pactl list sinks | sed -nre 's:^.*Volume.*front.* ([0-9]+)%.*:\1:p' -e 's/.*Mute: //p'))

if [ ! -z $1 ]; then
  echo '${color2}'${sound[1]}'%'
  if [ ${sound[0]} = 'no' ]; then
    #echo -n '${color1}🔊'
    echo -n '${color1}Sound'
  else
    #echo -n '${color1}🔇'
    echo -n '${color1}MUTE'
  fi
else
  echo ${sound[1]}
fi
