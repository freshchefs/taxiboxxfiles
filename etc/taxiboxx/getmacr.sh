#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

IFACE=$1
if [ "$IFACE" = "" ]; then
    IFACE=eth0
fi
MAC=$(ip link show dev $IFACE | awk '/link\/ether/ { print $2 }')
echo -n $MAC
exit 0
