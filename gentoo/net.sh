#! /bin/sh

start ()
{
  ip netns add out
  ip netns add rawdog

  ip -n rawdog link add wgout0 type wireguard
  ip -n rawdog link set wgout0 netns out
  #ip netns exec out wg setconf wgout0 /etc/wireguard/azirevpn-se1.conf
  #ip netns exec out wg setconf wgout0 /etc/wireguard/azirevpn-no1.conf
  ip netns exec out wg setconf wgout0 /etc/wireguard/azirevpn-nl1.conf

  ip -n rawdog link add wg42 type wireguard
  ip -n rawdog link set wg42 netns 1
  wg setconf wg42 /etc/wireguard/wg42.conf

  #ip -n rawdog link add wg69 type wireguard
  #ip -n rawdog link set wg69 netns 1
  #wg setconf wg69 /etc/wireguard/wg69.conf

  # isolate physical interfaces:
  ip link set eth0 down
  ip link set eth1 down
  ip link set wlan0 down
  ip link set eth0 netns rawdog
  ip link set eth1 netns rawdog
  iw phy phy0 set netns name rawdog

  # up up and away: rawdog
  ip netns exec rawdog dhcpcd -b wlan0
  #ip netns exec rawdog dhcpcd -b eth0
  ip netns exec rawdog dhcpcd -b eth1
  ip netns exec rawdog wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant-wlan0.conf -iwlan0 # FIXME

  # up up and away: wg 1
  ip link set wg42 up
  ip addr add 10.42.0.6/24 dev wg42
  ip ro add 10.42.0.0/24 via 10.42.0.1 dev wg42

  # up up and away: wg out
  ip -n out link set wgout0 up
  ip -n out addr add 10.0.23.23/19 dev wgout0
  ip -n out ro add default dev wgout0

  # setup localhost everywhere:
  for ns in rawdog out; do
    ip -n $ns addr add dev lo 127.0.0.1/8
    ip -n $ns link set lo up
  done
}

stop ()
{
  killall dhcpcd wpa_supplicant || true
  ip -n rawdog link set eth0 down
  ip -n rawdog link set eth1 down
  ip -n rawdog link set wlan0 down

  ip -n rawdog link set eth0 netns 1
  ip -n rawdog link set eth1 netns 1
  ip netns exec rawdog iw phy phy0 set netns 1

  ip li delete wg42
  ip -n out li delete wgout0
}

restart ()
{
  stop
  start
}

$@
