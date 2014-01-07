#/bin/bash

work=`mktemp -d`

journalctl _SYSTEMD_UNIT=sshd.service -p 5 -a -n 5000  | sed -nre '/failure/ s/^.*rhost=([^ ]*).*$/\1/pg' | sort | uniq -c | sed -rne 's/^[ ]*([0-9]{3}|[4-9]) //p' > $work/ips.txt

iptables -N BANFILTERTMP

n=0
for i in `cat $work/ips.txt`; do
	n=$(( $n + 1 ))
	echo Banning $i 
	iptables -A BANFILTERTMP -s $i -j LOG --log-level 4 --log-prefix 'BANFILTER '
	iptables -A BANFILTERTMP -s $i -j DROP
done

iptables --rename-chain BANFILTER BANFILTEROLD
iptables --rename-chain BANFILTERTMP BANFILTER
iptables -D INPUT -j BANFILTEROLD
iptables -A INPUT -j BANFILTER
iptables -F BANFILTEROLD
iptables -X BANFILTEROLD

logger -i BANFILTER banned $n IPs

rm -rf $work
