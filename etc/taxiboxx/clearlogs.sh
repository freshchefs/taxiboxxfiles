#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

cd /tmp/log
I=0
for N in `ls -1 access_log.* | sort -r`; do
    if [ $I != 0 ]; then
        rm $N
    fi
    I=`expr $I + 1`
done
I=0
for N in `ls -1 error_log.* | sort -r`; do
    if [ $I != 0 ]; then
        rm $N
    fi
    I=`expr $I + 1`
done
exit 0
