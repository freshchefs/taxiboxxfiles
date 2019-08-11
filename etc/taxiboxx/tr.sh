#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/tr.php"
MAC="gw=$(getmac.sh)"

. /usr/share/libubox/jshn.sh

RT=
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
        RT=$(json_dump | sed 's/ //g')
        #echo $RT
        curl -L -k -s --data "${MAC}" --data-urlencode "${RT}" "${URL}"
    fi
fi
