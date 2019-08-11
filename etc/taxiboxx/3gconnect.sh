#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

IFSTAT=`ifstatus wwan | grep '"up": true'`
if [ "$IFSTAT" != "" ]; then
    exit 0
fi
SHPROC=`ps | awk '{ print $5 }' | grep '{3g.sh}'`
GCOMPROC=`ps | awk '{ print $5 }' | grep gcom`
if [ "$GCOMPROC" != "" -o "$SHPROC" != "" ]; then
    sleep 5
fi
PPPPROC=`ps | awk '{ print $5 }' | grep /usr/sbin/pppd`
if [ "$PPPPROC" != "" ]; then
    sleep 15
    IFSTAT=`ifstatus wwan | grep '"up": true'`
    if [ "$IFSTAT" != "" ]; then
        exit 0
    else
        ifdown wwan
        sleep 10
    fi
fi

PROD=""
for IFACE in /dev/ttyUSB?; do
    TPROD=`prodid.sh $IFACE`
    if [ "$TPROD" = "12d1/1c25/102" ]; then
        PROD=$TPROD
        break
    fi
done

if [ "$PROD" != "" ]; then
    if [ "$(uci -q get network.wwan.device)" != "$IFACE" ]; then
        uci set network.wwan.device="$IFACE"
        uci commit network.wwan
    fi
    comgt -s -d $IFACE /etc/taxiboxx/3greset.gcom
    if [ $? -ne 0 ]; then
        exit 1
    fi
    ifup wwan
else
    exit 1
fi
