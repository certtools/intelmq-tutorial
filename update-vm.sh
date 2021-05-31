#!/bin/bash

set -e

# wrong permissions on state file
sudo chown intelmq:intelmq /var/lib/intelmq/state.json

# missing permissions in rabbitmq
sudo systemctl start rabbitmq-server.service
sudo rabbitmqctl set_permissions intelmq ".*" ".*" ".*"
sudo rabbitmqctl set_permissions admin ".*" ".*" ".*"
sudo systemctl stop rabbitmq-server.service

# install new landing page
sudo cp /home/user/intelmq-tutorial/ansible/files/landingpage.html /var/www/html/index.html

# install default crontab
sudo crontab -u intelmq /home/user/intelmq-tutorial/ansible/files/default_crontab

# install update-vm script
sudo cp /home/user/intelmq-tutorial/update-vm.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/update-vm.sh

# update intelmq source
sudo -u intelmq git -C /opt/dev_intelmq/ checkout master
sudo -u intelmq git -C /opt/dev_intelmq/ pull --rebase origin master

# update intelmq packages
sudo apt update
sudo apt install -y intelmq intelmq-api intelmq-manager
