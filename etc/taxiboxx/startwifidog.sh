#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

TBOXDIR=/etc/taxiboxx
ENAB=$(uci -q get taxiboxx.wifidog.enable)
if [ "$ENAB" = "1" ]; then
    TXB_ID=$(uci -q get taxiboxx.wifidog.id)
    TXB_IFACE=$(uci -q get taxiboxx.wifidog.iface)
    TXB_SERVER=$(uci -q get taxiboxx.wifidog.server)
    TXB_PORT=$(uci -q get taxiboxx.wifidog.port)

    sed -e "s/TXB_ID/$TXB_ID/" $TBOXDIR/wifidog.conf.temp | sed -e "s/TXB_SERVER/$TXB_SERVER/" | sed -e "s/TXB_PORT/$TXB_PORT/" | sed -e "s/TXB_IFACE/$TXB_IFACE/" >/etc/wifidog.conf

    /etc/init.d/wifidog start
fi

