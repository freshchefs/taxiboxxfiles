#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

for CNT in $(seq 1 10); do
    sleep 1
    ping -c 1 -s 4 -W 5 -n 112.90.146.4 >/dev/null 2>&1
    CHK=$?
    if [ "$CHK" = "0" ]; then
        break
    fi
done
if [ "$CHK" != "0" ]; then exit 1; fi

. /usr/share/libubox/jshn.sh
json_init

CSSID=$(uci -q get wireless.ap0.ssid)
CBIP=$(uci -q get network.bat0.ipaddr)
MAC=$(ip link show dev eth0 | awk '/link\/ether/ { print $2 }' | tr -d ':')
if [ "$CSSID" != "FreeCityWiFi" ]; then
    URL="$(uci -q get taxiboxx.webservice.url)/inst/inst_check.php?mac=$MAC"
    INIT=`curl -L -s -k "$URL"`

    if [ "$INIT" = '{"status":"OK"}' ]; then
        uci set wireless.ap0.ssid=FreeCityWiFi
        uci set wireless.ap0.encryption=none
        uci delete wireless.ap0.key
        uci commit wireless
        wifi reload
    fi
fi
if [ "$CBIP" = "" ]; then
    URL="$(uci -q get taxiboxx.webservice.url)/inst/inst_getip.php?mac=$MAC"
    INIT=`curl -L -s -k "$URL"`
    json_load "$INIT"
    json_get_var STATUS status
    if [ "$STATUS" = "OK" ]; then
        json_select results
        json_select 1
        json_get_var IP ip
        uci set network.bat0.ipaddr=$IP
        uci commit network
        /etc/init.d/network reload
    fi
fi
