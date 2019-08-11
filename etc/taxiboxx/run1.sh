#!/bin/sh

sed -i '/\/etc\/taxiboxx\/jobs/ s/15/30/' /etc/crontabs/root

fgrep syscheck /etc/crontabs/root >/dev/null 2>&1
if [ $? != 0 ]; then
    echo '2,7,12,17,22,27,32,37,42,47,52,57 * * * *     if [ -x /etc/taxiboxx/syscheck.sh ]; then /etc/taxiboxx/syscheck.sh >/dev/null 2>&1; fi' >>/etc/crontabs/root
fi

if [ "$(uci -q get taxiboxx.wifidog.enable)" != "1" -a "$(cat /etc/.VERSION)" -ge 4 ]; then
    uci set taxiboxx.wifidog.enable=1
    uci commit taxiboxx
fi

if [ "$(uci -q get mwan3.wwan.count)" = "1" ]; then
    uci delete mwan3.wwan.track_ip
    uci delete mwan3.wwan.reliability
    uci delete mwan3.wwan.count
    uci delete mwan3.wwan.timeout
    uci delete mwan3.wwan.interval
    uci delete mwan3.wwan.down
    uci delete mwan3.wwan.up
    uci commit mwan3
fi

fgrep "119.29.158.244" /etc/config/mwan3 >/dev/null
if [ $? = 1 ]; then
    sed -i "s/112.91.80.186/119.29.158.244/" /etc/config/mwan3
fi

/etc/taxiboxx/driverssid.sh

grep '^/root/.ssh$' /etc/sysupgrade.conf >/dev/null
if [ $? = 1 ]; then
    echo /root/.ssh >>/etc/sysupgrade.conf
fi

if [ "$(uci -q get taxiboxx.webservice.adsurl)" = "" ]; then
    uci set taxiboxx.webservice.adsurl=http://server1.wificonnexion.com:3000/apps.html
    uci commit taxiboxx
fi

rm -f /etc/taxiboxx/run1.sh
exit 0
