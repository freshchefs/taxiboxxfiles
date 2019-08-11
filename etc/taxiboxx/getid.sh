#!/bin/sh
PATH=/usr/bin:/bin
export PATH
TBOX=/etc/taxiboxx

GW=`$TBOX/getmac.sh`

echo Content-type: application/json
echo ""

cat <<EOF
{"MAC":"$GW"}
EOF
exit 0

