#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
TBOX=/etc/taxiboxx
F=$1

. /usr/share/libubox/jshn.sh
json_init

OK=0
while read -t 2 LN; do
    json_load "$LN"
    json_get_var CLASS class
    if [ "$CLASS" = "TPV" ]; then
        json_get_var MODE mode
        json_get_var TIME time
        json_get_var LAT lat
        json_get_var LON lon
        json_get_var SPEED speed
        if [ "$MODE" = "2" -o "$MODE" = "3" ]; then
            DT=`echo ${TIME:0:19} | tr 'T' '+'`
            if [ "$F" == "url" ]; then
                echo "&gpstm=${DT}&lat=${LAT}&lon=${LON}&speed=${SPEED}"
            else
                echo $DT $LAT $LON $SPEED
            fi
            OK=1
        fi
        break
    fi
done
if [ $OK = 0 ]; then
    if [ "$F" == "url" ]; then
        echo "&gpstm=&lat=&lon=&speed="
    else
        echo NOGPS
    fi
fi
exec 0>&-
exec 1>&-
exec 2>&-
