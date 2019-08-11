#!/bin/sh
[ -f /etc/taxiboxx/config.sh ] && . /etc/taxiboxx/config.sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH
MAC=`getmac.sh`
URL="$(uci -q get taxiboxx.webservice.url)/authtaxi/exceprpt.php?"

MSG=$(echo "$1" | tr ' ' '+')
PARM="mac=${MAC}&msg=${MSG}"
curl -L -k -s -o/dev/null "${URL}${PARM}"

exit 0
