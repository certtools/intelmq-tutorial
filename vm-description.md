# Tutorial VM description

## Users
The following users exist:
* `user`:`user`, unprivileged
* `intelmq`:`intelmq`, unprivileged
* `root`:`root`

The unprivileged users can "sudo" to any other user without password.

The script `tutorial-update.sh` will update the locally cloned tutorial in `/home/user/intelmq-tutorial/` and re-render the Markdown files to HTML with `tutorial-to-html.sh`, see also below.

## SSH

An SSH server is running on port 22.

## IntelMQ installation

A "development installation" has been chosen as installation method so that all IntelMQ-installation related files are located in `/opt/intelmq` for a better overview.

The local git repository is located at `/opt/dev_intelmq`, installed as editable pip-installation. So any changes made to existing files in `/opt/dev_intelmq` are immediately available. For all other cases run `sudo pip3 -e /opt/dev_intelmq/`.

## Webserver

An Apache webserver is running on default port 80. In order to work through the tutorial, you will need to access this port with your browser.

The landing page on `/` provides a quick overview and links to all installed software and resources as well as some useful online resources.

### Tutorial

A local copy with HTML-rendered markdown files can be found at `/tutorial/`.

### IntelMQ Manager

The IntelMQ Manager is provided by at the `/manager/` URL

### IntelMQ Webinput CSV

The so-called webinput can be reached via `/webinput/`.

### IntelMQ Fody

A partial installation of Fody is provided: Only the Events/Stats component is installed. The interface is available at the `/stats` path.

The installation source is currently CERT.at's fork because of some added features and optimizations.

## Mailserver

A simple postfix and dovecot setup provides mail servers for local usage only, nothing is relayed to other mail servers and any mails to non-existing users and any domains are redirected to the user `user`.

No authentication is required to send mails via SMTP at default port 25. TLS and STARTTLS are not supported.

A simple webmail interface (rainloop) is available via the local webserver at the `/webmail/` path. Login is possible with for example `user@localhost` or `intelmq@localhost` and the passwords as described above.
Any other local mail program can be used to access the mails in mbox format in `/var/mail/`.

## RabbitMQ

The RabbitMQ server is neither started nor enabled (auto-started) by default. To start the server, run `systemctl start rabbitmq-server`.
A graphical management interface is provided on port 15672, you can login there with `admin`/`admin`.

Also an `intelmq` user with password `intelmq` exists. The default `guest` user only works on localhost.
