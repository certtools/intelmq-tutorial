# Tutorial Ansible scripts

This is for educational purpose only and INSECURE!

Steps to do before:

Install Debian 10.

Configure your local SSH configuration to resolve the host `malaga` accordingly, install sudo and add the unprivileged user to the `sudo` group:
```bash
su -
apt install sudo
usermod -aG sudo user
systemctl enable ssh.service
systemctl start ssh.service
```

Execute the script for example like this:
```bash
ansible-playbook ansible/playbook.yml -i malaga, -kKb
```

## Additional file

The GeoLite2 database cannot be automatically provided by the installation script as a license is required. You can find the instructions here:
https://dev.maxmind.com/geoip/geoip2/geolite2/
Place the file at the ansible/files directory here, or comment out the task and put the file to `/opt/intelmq/var/lib/bots/maxmind_geoip/GeoLite2-City.mmdb` on the VM.
