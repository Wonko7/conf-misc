#! /bin/sh

vpn_endpoint=azirevpn-nl1
lwg_interfaces="wg42 wg69"
eth_interfaces=$(ip -o li | cut -d: -f2 | grep 'eth')
#phy_interfaces=$(ip -o li | cut -d: -f2 | egrep '(wlan|eth)')

start ()
{
  ip netns add out
  ip netns add rawdog

  ip -n rawdog link add wgout0 type wireguard
  ip -n rawdog link set wgout0 netns out
  ip netns exec out wg setconf wgout0 /etc/wireguard/${vpn_endpoint}.conf

  for wg in $lwg_interfaces; do
    ip -n rawdog link add $wg type wireguard
    ip -n rawdog link set $wg netns 1
    wg setconf $wg /etc/wireguard/${wg}.conf
  done

  # isolate physical interfaces:
  for eth in $eth_interfaces; do
    ip link set $eth down
    ip link set $eth netns rawdog
  done
  ip link set wlan0 down
  iw phy phy0 set netns name rawdog

  # up up and away: rawdog
  ip netns exec rawdog /usr/libexec/iwd&
  ip netns exec rawdog dhcpcd -b wlan0
  for eth in $eth_interfaces; do
    ip netns exec rawdog dhcpcd -b $eth
    echo yes
  done
  #ip netns exec rawdog wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant-wlan0.conf -iwlan0

  # up up and away: wg42 & wg69
  for wg in $lwg_interfaces; do
    #ip a
    ip link set $wg up
    sh /etc/wireguard/${wg}.ip.sh
  done

  # up up and away: wgout0
  ip -n out link set wgout0 up
  ip netns exec out sh /etc/wireguard/${vpn_endpoint}.ip.sh
  ip -n out ro add default dev wgout0

  # setup localhost everywhere:
  for ns in rawdog out; do
    ip -n $ns addr add dev lo 127.0.0.1/8
    ip -n $ns link set lo up
  done
}

stop ()
{
  killall dhcpcd || true
  killall dhcpcd iwd wpa_supplicant || true
  for eth in $eth_interfaces; do
    ip -n rawdog link set $eth down
    ip -n rawdog link set $eth netns 1
  done
  ip -n rawdog link set wlan0 down
  ip netns exec rawdog iw phy phy0 set netns 1

  for wg in $lwg_interfaces; do
    ip li delete $wg
  done
  ip -n out li delete wgout0
}

restart ()
{
  stop
  start
}

init_azire ()
{
  cd /etc/wireguard
  for c in azirevpn-*conf; do
    dns=$(echo $c | sed -re 's/.*azirevpn-(\w+)\.conf/\1.wg.azirevpn.net/')
    ipconf=$(echo $c | sed -re 's/\.conf/.ip.sh/')
    peer_ip=$(dig +noall +answer $dns | sed -re 's/.*\s([^ ]+)$/\1/')
    sed -i $c -re 's/^(Address|DNS)/#\1/' -e "s/^(Endpoint = )[^:]+:([0-9]+)/\1$peer_ip:\2/"
    ip4=$(sed /etc/wireguard/$c -nre 's;#Address = ([^,]+), (.+)$;\1;p')
    ip6=$(sed /etc/wireguard/$c -nre 's;#Address = ([^,]+), (.+)$;\2;p')
    echo "ip addr add $ip4 dev wgout0" > $ipconf
    echo "ip addr add $ip6 dev wgout0" >> $ipconf
    echo $peer_ip
    #cat $ipconf
  done
}

$@
