#!/bin/sh

if [ "$(uci -q get network.lan2)" != "interface" ]; then
    echo add lan2
    uci add network interface
    uci rename network.@interface[-1]=lan2
    uci set network.lan2.proto=static
    uci set network.lan2.ipaddr=192.168.169.1
    uci set network.lan2.netmask=255.255.255.0
    uci commit network
fi
if [ "$(uci -q get wireless.ap1)" != "wifi-iface" ]; then
    echo add lan2 wireless
    uci add wireless wifi-iface
    uci rename wireless.@wifi-iface[-1]=ap1
    uci set wireless.ap1.device=radio1
    uci set wireless.ap1.network=lan2
    uci set wireless.ap1.mode=ap
    uci set wireless.ap1.hidden=0
    uci set wireless.ap1.ssid=12345678
    uci set wireless.ap1.key=12345678
    uci set wireless.ap1.encryption=psk-mixed+tkip+ccmp
    uci commit wireless
else
    uci set wireless.ap1.hidden=0
    uci commit wireless
fi
if [ "$(uci -q get dhcp.lan2)" != "dhcp" ]; then
    echo add lan2 dhcp
    uci add dhcp dhcp
    uci rename dhcp.@dhcp[-1]=lan2
    uci set dhcp.lan2.interface=lan2
    uci set dhcp.lan2.start=100
    uci set dhcp.lan2.limit=150
    uci set dhcp.lan2.leasetime=12h
    uci commit dhcp
fi
if [ "$(uci -q get firewall.drzone)" != "zone" ]; then
    echo add lan2 firewall
    uci add firewall zone
    uci rename firewall.@zone[-1]=drzone
    uci set firewall.drzone.name=lan2
    uci add_list firewall.drzone.network=lan2
    uci set firewall.drzone.input=ACCEPT
    uci set firewall.drzone.output=ACCEPT
    uci set firewall.drzone.forward=ACCEPT
    uci add firewall forwarding
    uci rename firewall.@forwarding[-1]=drfwd
    uci set firewall.drfwd.src=lan2
    uci set firewall.drfwd.dest=wan
    uci add firewall forwarding
    uci rename firewall.@forwarding[-1]=mdrfwd
    uci set firewall.mdrfwd.src=lan2
    uci set firewall.mdrfwd.dest=mwan
    uci add firewall forwarding
    uci rename firewall.@forwarding[-1]=3gdrfwd
    uci set firewall.3gdrfwd.src=lan2
    uci set firewall.3gdrfwd.dest=3gwan
    uci commit firewall
fi

exit 0
