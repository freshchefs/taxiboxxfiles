#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

TBOX=/etc/taxiboxx

iptables -n -v --line-number -L FORWARD 2>/dev/null | grep '^1 .* WFC_3g ' >/dev/null 2>&1
if [ "$?" != "0" ]; then
    while [ "$?" = "0" ]; do
        iptables -D FORWARD -o 3g-wwan -j WFC_3g
    done
    iptables -I FORWARD -o 3g-wwan -j WFC_3g
fi

if [ -x /etc/taxiboxx/pnpoly ]; then
    iptables -n -v --line-number -L OUTPUT 2>/dev/null | grep '^1 .* WFC_3g ' >/dev/null 2>&1
    if [ "$?" != "0" ]; then
        while [ "$?" = "0" ]; do
            iptables -D OUTPUT -o 3g-wwan -j WFC_3g
        done
        iptables -I OUTPUT -o 3g-wwan -j WFC_3g
    fi
fi
