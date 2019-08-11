#!/bin/sh

while true; do
    clear
    iw dev mesh0 station dump |
        awk '
BEGIN { print "MAC\t\t\tSIG\t\tAVG" }
/^Station/ { mac=$2 }
/signal:/ { sig=$2$3$4$5 }
/signal avg:/ { print mac "\t" sig "\t" $3$4$5$6 }
/tx bitrate:/ { tx=$3$4 }
/rx bitrate:/ { rx=$3$4 }
/expected throughput:/ { print "    Thp: " $3 "\tTx: " tx "\tRx: " rx }
'
    sleep 3
done

