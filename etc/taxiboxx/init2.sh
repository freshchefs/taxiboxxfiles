#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

BAT0MAC=$(uci -q get network.bat0.macaddr)
if [ "$BAT0MAC" = "" ]; then
    BAT0MAC=$(ip link show dev bat0 | fgrep 'link/ether' | awk '{ print $2 }')
    if [ "$BAT0MAC" != "" ]; then
        uci set network.bat0.macaddr=$BAT0MAC
        uci commit network
    fi
fi

[ -x /etc/taxiboxx/cmdqueue.sh ] && /etc/taxiboxx/cmdqueue.sh
[ -x /etc/taxiboxx/mon3g.sh ] && /etc/taxiboxx/mon3g.sh
[ -x /etc/taxiboxx/setssid.sh ] && /etc/taxiboxx/setssid.sh
[ -x /etc/taxiboxx/getwclist.sh ] && /etc/taxiboxx/getwclist.sh
[ -x /etc/taxiboxx/getarea.sh ] && /etc/taxiboxx/getarea.sh >/tmp/area.dat
[ -x /etc/taxiboxx/putinfo.sh ] && /etc/taxiboxx/putinfo.sh
[ -x /etc/taxiboxx/startwifidog.sh ] && /etc/taxiboxx/startwifidog.sh
sleep 5
[ -x /etc/taxiboxx/init3gfw.sh ] && /etc/taxiboxx/init3gfw.sh
[ -x /etc/taxiboxx/mongps.sh ] && /etc/taxiboxx/mongps.sh
[ -x /etc/taxiboxx/wcsetup.sh ] && /etc/taxiboxx/wcsetup.sh
[ -x /etc/taxiboxx/wcmon.sh ] && /etc/taxiboxx/wcmon.sh
[ -x /etc/taxiboxx/dhcpmon.sh ] && /etc/taxiboxx/dhcpmon.sh
[ -x /etc/taxiboxx/blimit.sh ] && /etc/taxiboxx/blimit.sh
[ -x /etc/taxiboxx/syncapks.sh ] && /etc/taxiboxx/syncapks.sh

exit 0
