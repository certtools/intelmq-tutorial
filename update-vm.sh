#!/bin/bash

set -e

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
sudo chmod +x /usr/local/bin/update-vm.sh

# update intelmq
pushd /opt/dev_intelmq/
sudo -u intelmq git checkout master
sudo -u intelmq git pull --rebase origin master
popd
sudo pip3 install -e /opt/dev_intelmq/

sudo crontab -u intelmq /home/user/intelmq-tutorial/ansible/files/default_crontab
