#!/bin/sh
PATH=/usr/sbin:/sbin:/usr/bin:/bin
export PATH

RT=`ip route | grep '^10.8.0.0'`
ip route add table 201 $RT
ip rule del prio 5 from all lookup 201 2>/dev/null
ip rule add prio 5 from all lookup 201
