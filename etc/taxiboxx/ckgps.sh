#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

CKTMP=/tmp/ckgps.tmp
GPSDD=$(uci -q get gpsd.core.device)
if [ "$GPSDD" != "" ]; then
    GPSDD=$(basename $GPSDD)
    GPSD=$(ps | awk "/gpsd .*$GPSDD\$/ { print \$1 }")
    if [ "$GPSD" = "" ]; then
        /etc/init.d/gpsd start
        sleep 5
    fi
fi

gpspipe -w -n6 >$CKTMP &
sleep 4
grep -e '"mode":2\|"mode":3' $CKTMP
exit $?

