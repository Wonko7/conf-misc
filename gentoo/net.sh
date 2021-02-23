#! /bin/sh

vpn_endpoint=azirevpn-nl1
lwg_interfaces="wg42 wg69"
#phy_interfaces=$(ip -o li | cut -d: -f2 | egrep '(wlan|eth)')

start ()
{
  eth_interfaces=$(ip -o li | cut -d: -f2 | grep 'eth')
  wlan_interfaces=$(ip -o li | cut -d: -f2 | grep 'wlan')
  wphy_interfaces=$(iw phy | sed -nre 's/^Wiphy //p')
  ip netns add rawdog

  ip -n rawdog link add wgout0 type wireguard
  ip -n rawdog link set wgout0 netns 1
  wg setconf wgout0 /etc/wireguard/${vpn_endpoint}.conf
  #ip netns exec out wg setconf wgout0 /etc/wireguard/${vpn_endpoint}.conf

  for wg in $lwg_interfaces; do
    echo @@ starting $wg
    ip -n rawdog link add $wg type wireguard
    ip -n rawdog link set $wg netns 1
    wg setconf $wg /etc/wireguard/${wg}.conf
  done

  # isolate physical interfaces:
  for eth in $eth_interfaces; do
    echo @@ starting $eth
    ip link set $eth down
    ip link set $eth netns rawdog
  done
  for wlan in $wlan_interfaces; do
    echo @@ starting $wlan
    ip link set $wlan down
  done
  for phy in $wphy_interfaces; do
    echo @@ starting $phy
    iw phy $phy set netns name rawdog
  done

  ip netns exec rawdog /usr/libexec/iwd&
  wlan_interfaces=$(ip -n rawdog -o li | cut -d: -f2 | grep 'wlan')
  # FIXME: wlan gets renamed at this point for some reason
  sleep 1
  eth_interfaces=$(ip -n rawdog -o li | cut -d: -f2 | grep 'eth')
  wlan_interfaces=$(ip -n rawdog -o li | cut -d: -f2 | grep 'wlan')

  # up up and away: rawdog
  for i in $eth_interfaces $wlan_interfaces; do
    echo @@ starting dhcp on $i
    ip netns exec rawdog dhcpcd -b $i
  done
  #ip netns exec rawdog wpa_supplicant -B -c/etc/wpa_supplicant/wpa_supplicant-wlan0.conf -iwlan0

  # up up and away: wg42 & wg69
  for wg in $lwg_interfaces; do
    echo @@ starting ip conf on $wg
    ip link set $wg up
    sh /etc/wireguard/${wg}.ip.sh
  done

  # up up and away: wgout0
  ip link set wgout0 up
  sh /etc/wireguard/${vpn_endpoint}.ip.sh
  ip route add default dev wgout0

  # setup localhost everywhere:
  for ns in rawdog out; do
    ip -n $ns addr add dev lo 127.0.0.1/8
    ip -n $ns link set lo up
  done
}

stop ()
{
  eth_interfaces=$(ip -n rawdog -o li | cut -d: -f2 | grep 'eth')
  wlan_interfaces=$(ip -n rawdog -o li | cut -d: -f2 | grep 'wlan')
  wphy_interfaces=$(ip netns exec rawdog iw phy | sed -nre 's/^Wiphy //p')

  killall dhcpcd || true
  killall dhcpcd iwd wpa_supplicant || true
  for eth in $eth_interfaces; do
    echo @@ stopping $eth
    ip -n rawdog link set $eth down
    ip -n rawdog link set $eth netns 1
  done

  for wlan in $wlan_interfaces; do
    echo @@ stopping $wlan
    ip -n rawdog link set $wlan down
  done
  for phy in $wphy_interfaces; do
    echo @@ stopping $phy
    ip netns exec rawdog iw phy $phy set netns 1
  done

  for wg in $lwg_interfaces wgout0; do
    ip li delete $wg
  done

  case `hostname` in
    enterprise|daban-urnud|rocinante)
      echo @@ iwlwifi reload
      rmmod iwlmvm iwlwifi
      modprobe iwlwifi
      ;;
    yggdrasill)
      echo @@ ath10k reload
      rmmod ath10k_pci ath10k_core
      modprobe ath10k_pci
      ;;
  esac
}

restart ()
{
  stop
  sleep 5
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
