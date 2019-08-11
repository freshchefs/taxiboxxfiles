#!/bin/sh

N=/dev/mmcblk0

if [ -b $N ]; then
    D=`block info | fgrep 'LABEL="SWAP"'`
    if [ "$D" = "" ]; then
        sfdisk -uS $N <<EOF
1024,525311,S
526335,,L
EOF
        mkswap -L SWAP ${N}p1
        mke2fs -t ext4 -O ^has_journal -L DATA ${N}p2
        block mount
        if [ ! -f /mnt/flashdrive/.not.mounted ]; then
            mkdir -p /mnt/flashdrive/videos
            echo "<html></html>" >/mnt/flashdrive/videos/index.html
            mkdir -p /mnt/flashdrive/logs
            mkdir -p /mnt/flashdrive/vstaging
        fi
    else
        echo "already initialized"
    fi
else
    echo "no disk"
fi
exit 0
