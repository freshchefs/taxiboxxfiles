#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
DEV="$1"
DEVPATH=`udevadm info --name="$DEV" --query=path 2>/dev/null`
PRODUCT=""

if [ "$DEVPATH" != "" ]; then
    LVL=4
    while [ $LVL -gt 0 ]; do
        udevadm info --query=property --path="$DEVPATH" >/tmp/devinfo.tmp 2>/dev/null
        if [ $? -eq 0 ]; then
            . /tmp/devinfo.tmp
            if [ "$PRODUCT" != "" ]; then
                break
            fi
        fi
        LVL=$(expr $LVL - 1)
        DEVPATH=$(dirname $DEVPATH)
    done
fi

echo "$PRODUCT"
exit 0
