#!/bin/sh

IFACE=3g-wwan
BWDIR=/mnt/flashdrive/bw
MAXBW=5000000000

mon3g() {
    
}

if [ ! -f /mnt/flashdrive/.not.mounted ]; then
    mkdir -p $BWDIR
    touch $BWDIR/$IFACE
    
fi
