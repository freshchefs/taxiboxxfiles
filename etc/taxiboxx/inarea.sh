#!/bin/sh
PATH=/etc/taxiboxx:/usr/bin:/usr/sbin:/bin:/sbin
export PATH

TLAT=$1
TLON=$2

MAC="$(getmac.sh)"
URLP="$(uci -q get taxiboxx.webservice.url)"
if [ "$URLP" = "" ]; then
    URLP=http://server1.wificonnexion.com
fi
URL="$URLP/authtaxi/getarea.php?f=i&gw=$MAC"
. /usr/share/libubox/jshn.sh

ALIST=$(curl -L -k -s "$URL")
json_load "$ALIST"
json_get_var STATUS result
if [ "$STATUS" = "OK" ]; then
    json_select area
    I=1
    while json_get_type type $I && [ "$type" = "object" ]; do
        json_select $I
        json_get_var LAT lat
        json_get_var LON lon
        echo $LAT $LON
        json_select ..
        I=$(($I + 1))
    done
fi


int pnpoly(int nvert, float *vertx, float *verty, float testx, float testy)
{
  int i, j, c = 0;
  for (i = 0, j = nvert-1; i < nvert; j = i++) {
    if ( ((verty[i]>testy) != (verty[j]>testy)) &&
     (testx < (vertx[j]-vertx[i]) * (testy-verty[i]) / (verty[j]-verty[i]) + vertx[i]) )
       c = !c;
  }
  return c;
}
