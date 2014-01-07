#/bin/bash

work=`mktemp -d`

journalctl _SYSTEMD_UNIT=sshd.service -p 6 -a -n 10000  | sed -nre '/failure/ s/^.*rhost=([^ ]*).*$/\1/p' \
	-e '/BREAK/ s/^.*getaddrinfo.*\[([^ ]*)\].*$/\1/p' \
	 | sort | uniq -c > $work/ips.txt

# -e 'Received disconnect.*preauth/ s/.*Received disconnect from ([^:]*):.*/\1/p'

if [ "$1" = "show" ]; then
	echo showing:
	cat $work/ips.txt
	rm -rf $work
	exit
fi


iptables -N BANFILTERTMP

n=0
for i in `sed -rne 's/^[ ]*([0-9]{3}|[4-9]) //p' $work/ips.txt`; do
	n=$(( $n + 1 ))
	echo Banning $i 
	iptables -A BANFILTERTMP -s $i -j LOG --log-level 4 --log-prefix 'BANFILTER ' #for debug
	iptables -A BANFILTERTMP -s $i -j DROP
done

iptables --rename-chain BANFILTER BANFILTEROLD
iptables --rename-chain BANFILTERTMP BANFILTER
iptables -D INPUT -j BANFILTEROLD
iptables -I INPUT -j BANFILTER
iptables -F BANFILTEROLD
iptables -X BANFILTEROLD

logger -i BANFILTER banned $n IPs

rm -rf $work
