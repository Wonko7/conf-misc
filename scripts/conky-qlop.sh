#! /bin/sh

current=`qlop -c`
if [ -z "$current" ]; then
	exit 0
fi
echo -n 
echo $current | sed -nre "1 s:^.*/(\S+).*:\1:p"
