#!/bin/bash
image=${1:-'rpio/torproxy'}
IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

# Default ports + daemonized docker container
DID=$(docker run -h 'torproxy.localdomain' -p 9001:9001 -p 9030:9030 -p 9050:9050 -p 8118:8118 --name torproxy -d $image) && echo $DID > /tmp/torproxy.did
