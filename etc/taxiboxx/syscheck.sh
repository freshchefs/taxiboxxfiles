#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
MNTPATH=/mnt/flashdrive
#CURR=`date "+%Y-%m-%d %H:%M:%S"`

[ -f /tmp/.nock ] && exit 0

stopgps() {
    killall -q mongps.sh gpspipe
    /etc/init.d/gpsd stop
    sleep 3
}

startgps() {
    /etc/taxiboxx/mongps.sh
}

/etc/taxiboxx/init3gfw.sh || true

/etc/taxiboxx/3gconnect.sh || true

cat /mnt/flashdrive/videos/index.html >/dev/null
if [ $? != 0 ]; then
    exceprpt.sh "flash drive failed"
fi

cd /tmp
gpspipe -w >testgps.out 2>/dev/null &
TESTGPS=$!
sleep 5
kill $TESTGPS
N=$(wc -l testgps.out | awk '{ print $1 }')
if [ $N -lt 5 ]; then
    exceprpt.sh "GPS failed"
    stopgps
    startgps
fi

exit 0
