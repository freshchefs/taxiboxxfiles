#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

VER=$(cat /etc/.VERSION 2>/dev/null)
VER=${VER:-0}
[ $VER -lt 5 ] && exit 1
[ "$(uci -q get taxiboxx.wifidog.enable)" != "1" ] && exit 1
CNT=0

while true; do
    [ $CNT -gt 10 ] && exit 1
    iptables -t mangle -L WiFiDog_br-lan_Trusted >/dev/null 2>&1
    if [ "$?" = "0" ]; then
        sleep 1
        break
    fi
    sleep 3
    CNT=$(($CNT + 1))
done

iptables -t mangle -L PREROUTING | fgrep WFCWC >/dev/null 2>&1
if [ "$?" != "0" ]; then
    iptables -t mangle -I PREROUTING 1 -i br-lan -p tcp --dport 80 -m string --algo bm --from 40 --to 256 --string 'micromessenger' -j LOG --log-prefix 'WFCWC: '
fi

iptables -t mangle -L PREROUTING | grep '^MARK .* xset 0x2/0xff$' >/dev/null 2>&1
if [ "$?" != "0" ]; then
    iptables -t mangle -I PREROUTING 1 -i br-lan -p tcp --dport 80 -m string --algo bm --from 40 --to 256 --string 'micromessenger' -j MARK --set-xmark 0x2/0xff
fi

iptables -L WiFiDog_br-lan_Global | fgrep micromessenger >/dev/null 2>&1
if [ "$?" != "0" ]; then
    iptables -I WiFiDog_br-lan_Global -p tcp --dport 80 -m string --algo bm --from 40 --to 256 --string 'micromessenger' -j ACCEPT
fi
