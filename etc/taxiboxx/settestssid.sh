#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

CSSID=$(uci -q get wireless.ap0.ssid)
if [ "$CSSID" != "TxMeshTest" ]; then
    uci set wireless.ap0.ssid=TxMeshTest
    uci set wireless.ap0.encryption=none
    uci delete wireless.ap0.key
    uci commit wireless
    wifi reload
fi
