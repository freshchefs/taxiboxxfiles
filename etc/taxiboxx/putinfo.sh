#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
. /usr/share/libubox/jshn.sh

C_TYPE=
URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/updinfo.php?"
touch /tmp/.c_type

PARM=""
GW_ID=$(getmac.sh)
VER=$(cat /etc/.VERSION)
SVER=$(cat /etc/taxiboxx/.VERSION)
PARM="mac=${GW_ID}&ver=${VER}&sver=${SVER}"
cd /sys/class/net
MACS=""
for I in *; do
    MAC=$(cat $I/address)
    if [ "$MAC" != "" -a "$MAC" != "00:00:00:00:00:00" ]; then
        MACS="${MACS}&${I}=${MAC}"
        #echo $I $MAC
    fi
done

#echo ${URL}${PARM}${MACS}
R=$(curl -L -k -s "${URL}${PARM}${MACS}")
json_load "$R"
json_get_var RESULT result
if [ "$RESULT" = "OK" ]; then
  json_select data
  json_get_var C_TYPE c_type
  echo "$C_TYPE" >/tmp/.c_type
fi

exit 0
