#!/bin/bash

# wrong permissions on state file
sudo chown intelmq:intelmq /opt/intelmq/var/lib/state.json

# missing permissions in rabbitmq
sudo systemctl start rabbitmq-server.service
sudo rabbitmqctl set_permissions intelmq ".*" ".*" ".*"
sudo rabbitmqctl set_permissions admin ".*" ".*" ".*"
sudo systemctl stop rabbitmq-server.service

# install new landing page
sudo cp /home/user/intelmq-tutorial/ansible/files/landingpage.html /var/www/html/index.html

# install update-vm script
sudo cp /home/user/intelmq-tutorial/update-vm.sh /usr/local/bin/
chmod +x /usr/local/bin/update-vm.sh
