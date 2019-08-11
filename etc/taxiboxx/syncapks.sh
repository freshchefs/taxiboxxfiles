#!/bin/sh
PATH=/etc/taxiboxx:$PATH
HOME=/root
export PATH HOME

[ -f /mnt/flashdrive/.not.mounted ] && exit 1
SRV=syncapks@$(uci -q get taxiboxx.wifidog.server)
APKDIR=/mnt/flashdrive/apks
RMTDIR=/var/local/wfc/apks
GW="gw=$(getmac.sh)"
URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/updapks.php"
mkdir -p $APKDIR

main() {
    while true; do
        /etc/taxiboxx/jobs/00-delay
        cd $APKDIR
        rsync -ar --no-owner --no-group --delete ${SRV}:${RMTDIR}/ .
        if [ $? = 0 ]; then
            curl -L -k -s --data "$GW" ${URL}
        fi
        sleep 14400
    done
}

main &
