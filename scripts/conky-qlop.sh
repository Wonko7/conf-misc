#! /bin/sh

current=`genlop -c | sed -nre '/ \* / s: \* ::p'`
if [ -z "$current" ]; then
  uname --kernel-release
  exit 0
fi
echo -n 
echo $current | sed -nre "1 s:^.*/(\S+).*:\1:p"
