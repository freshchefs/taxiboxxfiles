#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/wcuser.php?"
GW_ID="gw_id=$(/etc/taxiboxx/getmac.sh)"
VER=$(cat /etc/.VERSION 2>/dev/null)
VER=${VER:-0}
[ $VER -lt 5 ] && exit 1

main() {
    logread -f | while true; do
        read WCLOG
        echo $WCLOG | fgrep WFCWC: >/dev/null 2>&1
        [ "$?" != "0" ] && continue
        eval $(echo $WCLOG  | awk '{ print $12 " " $13 " " $14 " " $15 " " $16 }')
        MAC=$(ip neigh | awk "/^$SRC / { print \$5 }")
        if [ "$MAC" != "" ]; then
            iptables -t mangle -n -v -L WiFiDog_br-lan_Trusted | awk '/ MAC / { print $11 }' | fgrep -i "$MAC" >/dev/null 2>&1
            [ "$?" != "0" ] && \
                iptables -t mangle -A WiFiDog_br-lan_Trusted -m mac --mac-source "$MAC" -j MARK --set-xmark 0x2/0xff
                MAC="mac=${MAC}"
                IP="ip=${SRC}"
                curl -L -k -s -o/dev/null "${URL}${MAC}&${IP}&${GW_ID}"
        fi
    done
}

main &

exit 0
