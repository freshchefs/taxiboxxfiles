#!/bin/sh
#mongpsrslt.sh "$GW" "$DT" "$LAT" "$LON" "$SPEED" "$NET" "$NETM" "$NET3" 
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/stcollect.php"
GW="gw=$1"
DT="gpstm=$2"
LAT="lat=$3"
LATR="$3"
LON="lon=$4"
LONR="$4"
SPEED="speed=$5"
NET="net=$6"
NETM="netm=$7"
NET3="net3=$8"
LAREA=0
INAREA=
R=
. /usr/share/libubox/jshn.sh


if [ -x /etc/taxiboxx/pnpoly ]; then
    INAREA=$(pnpoly $LATR $LONR $(cat /tmp/area.dat))
    LAREA=1
fi

if [ "$INAREA" != "0" ]; then
    RT="rt="
    mwan3 interfaces | fgrep 'bat0 is online' >/dev/null 2>&1
    if [ "$?" = "0" ]; then
        DROUTE=$(ip route | grep '^default via .* bat0' | awk '{ print $3 }')
        if [ "$DROUTE" != "" ]; then
            I=0
            json_init
            json_add_array 'route'
            for A in `batctl tr -n $DROUTE | awk '{ if ($0 !~ /^traceroute to/) { print $2; } }'`; do
                json_add_string $I $A
                I=$(($I + 1))
            done
            json_close_array
            RT="rt=$(json_dump | sed 's/ //g')"
        fi
    fi
    R=`curl -L -k -s --data "$GW" --data-urlencode "$DT" --data "$LAT" --data "$LON" --data "$SPEED" --data "$NET" --data "$NETM" --data "$NET3" --data-urlencode "$RT" "${URL}"`
    json_load "$R"
    json_select data
fi

if [ $LAREA = 0 -a "$INAREA" != "0" ]; then
    json_get_var INAREA inarea
fi

if [ "$INAREA" = "0" ]; then
    iptables --line-number -L WFC_3g | fgrep 'REJECT' >/dev/null 2>&1 || iptables -A WFC_3g -j REJECT
    if [ ! -f /tmp/.wifioff ]; then
        touch /tmp/.wifioff
        uci set wireless.radio1.disabled=1
        uci commit wireless.radio1
        wifi reload
        sleep 2
        uci set wireless.radio1.disabled=0
        uci commit wireless.radio1
    fi
elif [ "$INAREA" = "1" -o "$INAREA" = "" ]; then
    while [ $? = 0 ]; do
        iptables -D WFC_3g -j REJECT 2>/dev/null
    done
    if [ -f /tmp/.wifioff ]; then
        /sbin/reboot
    fi
fi
