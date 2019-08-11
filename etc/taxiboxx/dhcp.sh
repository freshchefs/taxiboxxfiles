#!/bin/sh
#<func> <mac> <ip> <host>
PATH=/etc/taxiboxx:$PATH
export PATH

FN=$1
MAC=$2
IP=$3
HST=$4
IP3=$(echo "$IP" | awk -F. '{ print $3 }')
GW_ID="gw_id=$(/etc/taxiboxx/getmac.sh)"
MACP="mac=$MAC"
IPP="ip=$IP"
touch /tmp/.driver

if [ \( "$FN" = "add" -o "$FN" = "old" \) -a "$IP3" = "169" ]; then
    . /usr/share/libubox/jshn.sh
    URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/drvlogin.php?"
    R=`curl -L -k -s "${URL}${MACP}&${IPP}&${GW_ID}"`
    json_load "$R"
    json_get_var RESULT result
    if [ "$RESULT" = "OK" ]; then
        json_select data
        json_get_var DRV drv
        if [ "$DRV" = "1" ]; then
            echo "$MAC" >/tmp/.driver
        fi
    fi
fi
exit 0
