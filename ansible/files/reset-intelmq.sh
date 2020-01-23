#!/bin/bash

[ "root" != "$USER" ] && exec sudo $0 "$@"

pkill -u intelmq -f "/usr/bin/python3 /usr/local/bin/intelmq.bots"

redis-cli -c "flushall"

cp /opt/dev_intelmq/intelmq/etc/* /opt/intelmq/etc/
cp /opt/dev_intelmq/intelmq/bots/BOTS /opt/intelmq/etc/
