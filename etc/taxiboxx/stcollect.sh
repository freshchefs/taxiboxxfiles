#!/bin/sh
[ -f /etc/taxiboxx/config.sh ] && . /etc/taxiboxx/config.sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
TBOX=/etc/taxiboxx
URL="http://${TXB_SERVER}/authtaxi/stcollect.php?"
PGPSLAT=X
PGPSLON=X

sleep 5

main() {
    GW=`$TBOX/getmac.sh`
    GPSSTR="`gpspipe -w -n8 </dev/null | $TBOX/getll1.sh`"
    if [ "$GPSSTR" == "NOGPS" ]; then
        GPSLAT=
        GPSLON=
        GPSSPEED=
        GPSDATA="&gpstm=&lat=&lon=&speed="
    else
        GPSTM="`echo $GPSSTR | awk '{ print $1 }'`"
        GPSLAT="`echo $GPSSTR | awk '{ print $2 }'`"
        GPSLON="`echo $GPSSTR | awk '{ print $3 }'`"
        GPSSPEED="`echo $GPSSTR | awk '{ print $4 }'`"
        GPSDATA="&gpstm=${GPSTM}&lat=${GPSLAT}&lon=${GPSLON}&speed=${GPSSPEED}"
    fi

    STAT=-1
    PSTAT=-1
    PARM="gw=${GW}${GPSDATA}&state=${STAT}&pstate=${PSTAT}"

    if [ "$GPSLAT" != "$PGPSLAT" -o "$GPSLON" != "$PGPSLON" ]; then
        curl -L -k -s -o/dev/null "${URL}${PARM}"
    fi
    PGPSLAT=$GPSLAT
    PGPSLON=$GPSLON
}

while true; do
    main
    sleep 15
done
