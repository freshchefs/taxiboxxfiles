#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
IFACE=$1
for i in `iwinfo $IFACE assoclist | grep '^[0-9A-F]' | awk '{ print tolower($1) }'`; do
    #j=`grep $i /tmp/dhcp.leases | awk '{ print $3 }'`
    echo -n '&mac%5B%5D='${i}
done
