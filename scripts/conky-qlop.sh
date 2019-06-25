#! /bin/sh

current=`genlop -c  2> /dev/null | sed -nre '/ \* / s: \* ::p'`
if [ -z "$current" ]; then
  uname --kernel-release
  exit 0
fi
echo -n 
echo $current | sed -nre "1 s:^.*/(\S+).*:\1:p"
