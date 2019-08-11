#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

cd /dev
for N in ttyUSB*; do
    D=`udevadm info  --attribute-walk --name=$N | fgrep pl2303 | wc -l`
    if [ $D -gt 0 ]; then
        rm -f tty_GPS
        ln -s $N tty_GPS
    fi
    D=`udevadm info  --attribute-walk --name=$N | fgrep ch341 | wc -l`
    if [ $D -gt 0 ]; then
        rm -f tty_FLAG
        ln -s $N tty_FLAG
    fi
done
