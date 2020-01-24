#!/bin/bash

# wrong permissions on state file
sudo chown intelmq:intelmq /opt/intelmq/var/lib/state.conf

# missing permissions in rabbitmq
sudo systemctl start rabbitmq-server.service
rabbitmqctl set_permissions intelmq ".*" ".*" ".*"
rabbitmqctl set_permissions admin ".*" ".*" ".*"
systemctl stop rabbitmq-server.service
