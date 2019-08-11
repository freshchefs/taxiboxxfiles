#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

CK=$(ip addr show dev 3g-wwan | awk '/ inet / { print $2 }')
if [ "$CK" = "" ]; then
    exit 1
else
    exit 0
fi

