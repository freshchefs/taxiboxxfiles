#!/bin/sh

MAC=$(ip link show dev eth0 | awk '/link\/ether/ { print $2 }' | tr -d ':')
echo -n $MAC
exit 0
