#!/bin/sh
PATH=/etc/taxiboxx:$PATH
export PATH

[ -f /mnt/flashdrive/.not.mounted ] && exit 1
FWDIR=/mnt/flashdrive/fw
mkdir -p $FWDIR
CV=$(cat /etc/.VERSION)
SV=$(cat /mnt/flashdrive/fw/fw.ver)
if [ "$CV" = "" ]; then CV=0; fi
if [ "$SV" = "" ]; then SV=0; fi
cd $FWDIR

if [ $SV -gt $CV ]; then
    md5sum -c fw.md5
    if [ "$?" = "0" ]; then
        sysupgrade fw.bin
        exit 0
    else
        rm -f $FWDIR/*
    fi
fi

FWDIR=/mnt/flashdrive/sw
mkdir -p $FWDIR
CV=$(cat /etc/taxiboxx/.VERSION)
SV=$(cat /mnt/flashdrive/sw/sw.ver)
if [ "$CV" = "" ]; then CV=0; fi
if [ "$SV" = "" ]; then SV=0; fi
cd $FWDIR

if [ $SV -gt $CV ]; then
    md5sum -c sw.md5
    if [ "$?" = "0" ]; then
        cd /
        mv /etc/taxiboxx/.VERSION /etc/taxiboxx/.PVERSION
        tar xvzf $FWDIR/sw.tar.gz
        [ -x /etc/taxiboxx/run1.sh ] && /etc/taxiboxx/run1.sh
        [ -f /tmp/.reboot ] && /sbin/reboot
    else
        rm -f $FWDIR/*
    fi
fi
