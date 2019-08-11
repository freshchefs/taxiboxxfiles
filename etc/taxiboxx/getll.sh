#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
. /usr/share/libubox/jshn.sh
json_init

while read -t 2 LN; do
    json_load "$LN"
    json_get_var CLASS class
    if [ "$CLASS" = "TPV" ]; then
        json_get_var MODE mode
        if [ "$MODE" = 2 -o "$MODE" = 3 ]; then
            json_get_var TIME time
            json_get_var LAT lat
            json_get_var LON lon
            json_get_var SPEED speed
            DT=`echo ${TIME:0:19} | tr 'T' ' '`
            echo $DT $LAT $LON $SPEED
        else
            echo NOGPS
        fi
    fi
done
