#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

URLP="$(uci -q get taxiboxx.webservice.wcurl)"
if [ "$URLP" = "" ]; then
    URLP=http://server1.wificonnexion.com:3000
fi
URL="$URLP/test/wechat"
. /usr/share/libubox/jshn.sh

ipset list wc >/dev/null 2>&1
if [ "$?" != "0" ]; then
    ipset create wc hash:net
fi
IPLIST=$(curl -L -k -s "$URL")
json_load "$IPLIST"
json_get_var STATUS status
if [ "$STATUS" = "OK" ]; then
    ipset flush wc
    json_select results
    I=1
    while json_get_type type $I && [ "$type" = "string" ]; do
        json_get_var IP "$((I++))"
        ipset add wc "$IP"
    done
fi

ipset add wc 140.207.137.32
ipset add wc 140.206.160.199
ipset add wc 140.207.62.51
ipset add wc 203.205.143.142

ipset add wc 140.206.160.234
ipset add wc 140.207.54.47
ipset add wc 140.207.135.125
ipset add wc 203.205.151.193

ipset add wc 118.212.137.18  
ipset add wc 113.207.16.65
ipset add wc 42.48.109.18   
ipset add wc 121.31.22.153 

ipset add wc 203.205.147.177
ipset add wc 103.7.30.34
ipset add wc 58.251.61.149
ipset add wc 163.177.83.164

