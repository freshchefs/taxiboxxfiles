#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

TBOX=/etc/taxiboxx
URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/stcollect.php?"
GSTAT=/tmp/run/gstat.dat
PGPSLAT=
PGPSLON=
CNTR=0
GW=`$TBOX/getmac.sh`
PIPE=/var/run/cmd.pipe

. /usr/share/libubox/jshn.sh

main() {
    gpspipe -w | while true; do
        read -t 2 GPSSTR
        DT=
        LAT=
        LON=
        SPEED=
        if [ "$GPSSTR" = "" ]; then
            GPSSTR='{"class":"TPV","mode":0}'
        fi
        if [ $(($CNTR % 7)) = 0 ]; then
            json_load "$GPSSTR"
            json_get_var CLASS class
            if [ "$CLASS" = "TPV" ]; then
                json_get_var MODE mode
                if [ "$MODE" = 2 -o "$MODE" = 3 ]; then
                    json_get_var TIME time
                    json_get_var LAT lat
                    json_get_var LON lon
                    json_get_var SPEED speed
                    DT=`echo ${TIME:0:19} | tr 'T' '+'`
                    NOGPS=0
                    echo $DT $LAT $LON $SPEED >$GSTAT
                else
                    NOGPS=1
                    echo NOGPS >$GSTAT
                fi
                if [ "$LAT" != "$PGPSLAT" -o "$LON" != "$PGPSLON" ]; then
                    if [ "$(mwan3 interfaces | fgrep 'bat0 is online')" != "" ]; then NETM=Y; else NETM=N; fi
                    if [ "$(mwan3 interfaces | fgrep 'wwan is online')" != "" ]; then NET3=Y; else NET3=N; fi
                    NET=$(mwan3 policies | fgrep '100%' | awk '{ print $1 }')
                    if [ "$NET" = "bat0" ]; then
                        NET=M
                    elif [ "$NET" = "wwan" ]; then
                        NET=3
                    else
                        NET=""
                    fi
                    #NETDATA="&net=${NET}&netm=${NETM}&net3=${NET3}"
                    #GPSDATA="&gpstm=${DT}&lat=${LAT}&lon=${LON}&speed=${SPEED}"
                    #PARM="gw=${GW}${GPSDATA}${NETDATA}&state=-1&pstate=-1"
                    #$TBOX/mongpsrslt.sh "$PARM" ${LAT} ${LON} &
                    $TBOX/mongpsrslt.sh "$GW" "$DT" "$LAT" "$LON" "$SPEED" "$NET" "$NETM" "$NET3" &
                fi
                PGPSLAT=$LAT
                PGPSLON=$LON
            fi
        fi
        CNTR=$(($CNTR + 1))
    done

}

GPSDD=$(uci -q get gpsd.core.device)
if [ "$GPSDD" != "" ]; then
    GPSDD=$(basename $GPSDD)
    GPSD=$(ps | awk "/gpsd .*$GPSDD\$/ { print \$1 }")
    if [ "$GPSD" = "" ]; then
        /etc/init.d/gpsd start
        sleep 2
    fi
fi

main &
sleep 3

exit 0
