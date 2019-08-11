#!/bin/sh
. cgi-bin/tx_head.sh

BASE=0
/etc/taxiboxx/ckgps.sh </dev/null >/dev/null 2>&1
if [ $? != 0 ]; then BASE=$(( $BASE + 1 )); fi
/etc/taxiboxx/ck3g.sh </dev/null >/dev/null 2>&1
if [ $? != 0 ]; then BASE=$(( $BASE + 2 )); fi
/etc/taxiboxx/ckflashdrive.sh </dev/null >/dev/null 2>&1
if [ $? != 0 ]; then BASE=$(( $BASE + 4 )); fi

if [ "$BASE" != "0" ]; then
    BASE=$(( $BASE + 2000 ))
else
    BASE=OK
    uci set wireless.ap0.ssid=FreeCityWiFi
    uci set wireless.ap0.encryption=none
    uci delete wireless.ap0.key
    uci commit wireless
fi

echo "{\"status\":\"$BASE\"}"

exit 0
