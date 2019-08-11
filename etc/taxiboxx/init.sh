#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

touch /tmp/.nock
block mount
[ -x /etc/taxiboxx/initdisk.sh ] && /etc/taxiboxx/initdisk.sh
[ -x /etc/taxiboxx/upgrade.sh ] && /etc/taxiboxx/upgrade.sh
[ -x /etc/taxiboxx/run1.sh ] && /etc/taxiboxx/run1.sh
[ -x /etc/taxiboxx/3gconnect.sh ] && /etc/taxiboxx/3gconnect.sh
[ -x /etc/taxiboxx/init2.sh ] && /etc/taxiboxx/init2.sh
rm -f /tmp/.nock

exit 0
