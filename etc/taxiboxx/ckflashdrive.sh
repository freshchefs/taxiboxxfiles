#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

CK=/mnt/flashdrive/.not.mounted
if [ -f "$CK" ]; then
    exit 1
else
    exit 0
fi

