#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

MAC="$(getmac.sh)"
URLP="$(uci -q get taxiboxx.webservice.url)"
if [ "$URLP" = "" ]; then
    URLP=http://server1.wificonnexion.com
fi
URL="$URLP/authtaxi/getarea.php?f=f&gw=$MAC"
. /usr/share/libubox/jshn.sh

ALIST=$(curl -L -k -s "$URL")
json_load "$ALIST"
json_get_var STATUS result
if [ "$STATUS" = "OK" ]; then
    json_select area
    I=1
    while json_get_type type $I && [ "$type" = "object" ]; do
        json_select $I
        json_get_var LAT lat
        json_get_var LON lon
        echo $LAT $LON
        json_select ..
        I=$(($I + 1))
    done
fi

