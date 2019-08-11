#!/bin/sh

C_TYPE=$(cat /tmp/.c_type)
[ "$C_TYPE" = "1" ] && exit 0

DEV=wlan1-1
DEV2=wlan1
RATE=1228kbit
RRATE=1228kbit
LRATE=10mbit

#tc qdisc del dev $DEV root || true
#tc qdisc del dev $DEV ingress || true

#tc qdisc add dev $DEV root handle 1: htb default 1
#tc class add dev $DEV parent 1: classid 1:1 htb rate $RATE ceil $RATE
#tc filter add dev $DEV parent 1: protocol all u32 match u32 0 0 flowid 1:1

#tc qdisc add dev $DEV handle ffff: ingress
#tc filter add dev $DEV parent ffff: protocol all prio 1 u32 match u32 0 0 police rate $RATE burst 10k drop flowid :1

if [ "$(uci -q get network.wwan.apn)" = "zhkgkj.wxsc.gdapn" ]; then
    tc qdisc del dev $DEV2 root || true
    tc qdisc del dev $DEV2 ingress || true
    tc qdisc add dev $DEV2 root handle 1: htb default 2
    tc class add dev $DEV2 parent 1: classid 1:1 htb rate $LRATE ceil $LRATE
    tc class add dev $DEV2 parent 1: classid 1:2 htb rate $RRATE ceil $RRATE
    tc filter add dev $DEV2 parent 1: protocol ip u32 match ip src 192.168.168.1/32 flowid 1:1
    tc filter add dev $DEV2 parent 1: protocol ip u32 match ip src 112.90.146.0/29 flowid 1:1
    tc qdisc add dev $DEV2 handle ffff: ingress
    tc filter add dev $DEV2 parent ffff: protocol all prio 1 u32 match u32 0 0 police rate $RATE burst 10k drop flowid :1
fi

exit 0
