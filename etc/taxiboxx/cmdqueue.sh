#!/bin/sh
TBOXX=/etc/taxiboxx
PATH=$TBOXX:/usr/sbin:/sbin:/usr/bin:/bin
export PATH
PIPE=/var/run/cmd.pipe

if [ ! -e $PIPE ]; then
    mkfifo $PIPE
fi

tail -f $PIPE | \
    (TPID=$!
    echo $TPID
    while read -r CMD; do
        if [ "$CMD" = "quit" ]; then
            break
        fi
        eval "$CMD"
    done
    kill $TPID) >/var/log/cmd.log 2>&1 &

exit 0
