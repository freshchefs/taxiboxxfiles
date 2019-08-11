#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

main() {
    while true; do
        RT=$(ip route | awk '/default via .* dev bat0/ { print $3 }')
        if [ "$RT" != "" ]; then
            ping -I bat0 -W 2 -c 1 -s 4 $RT >/dev/null
            if [ $? != 0 -a -f /var/run/udhcpc-bat0.pid ]; then
                kill $(cat /var/run/udhcpc-bat0.pid)
                sleep 5
            fi
        fi
        sleep 5
    done
}

main &
