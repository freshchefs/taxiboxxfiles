#!/bin/sh
PATH=/usr/sbin:/sbin:/usr/bin:/bin
export PATH

ip rule del prio 5 from all lookup 201 2>/dev/null
