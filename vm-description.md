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

## Scripts

TODO

## Webserver

An Apache webserver is running on default port 80. In order to work through the tutorial, you will need to access this port with your browser. In the workshop materials we assume that you have set up port-forwarding on port 8080.

The landing page on `http://localhost:8080/` provides a quick overview and links to all installed software and resources as well as some useful online resources.

### Tutorial

A local copy with HTML-rendered markdown files can be found at `http://localhost:8080/tutorial/`.

### IntelMQ Manager

The IntelMQ Manager is provided by at the `http://localhost:8080/manager/` URL

### IntelMQ Webinput CSV

The so-called webinput can be reached via `http://localhost:8080/webinput/`.

### IntelMQ Fody

A partial installation of Fody is provided: Only the Events/Stats component is installed. The interface is available at the `/stats` path.

The installation source is currently CERT.at's fork because of some added features and optimizations.

## PostgreSQL

The local PostgreSQL is listening on the default port 5432 without TLS.
A database called `intelmq` is pre-configured with an `events` table, which is the result of the `intelmq_psql_initdb` tool.

### Authentication

* trust: all local connections (UNIX socket) are trusted, which means you can do `psql intelmq intelmq` as any user to connect to the `intelmq` database as user `intelmq`.
* network: to connect over the network, the user `intelmq` has the password `intelmq`, e.g. `psql intelmq intelmq -h localhost -W`.

## Mailserver

A simple postfix and dovecot setup provides mail servers for local usage only, nothing is relayed to other mail servers and any mails to non-existing users and any domains are redirected to the user `user`.

No authentication is required to send mails via SMTP at default port 25. TLS and STARTTLS are not supported.

A simple webmail interface (rainloop) is available via the local webserver at `http://localhost:8080/webmail/`. Login is possible with for example `user@localhost` or `intelmq@localhost` and the passwords as described above.
Any other local mail program can be used to access the mails in mbox format in `/var/mail/`.

## RabbitMQ

The RabbitMQ server is neither started nor enabled (auto-started) by default. To start the server, run `systemctl start rabbitmq-server`.
A graphical management interface is provided on port 15672, you can login there with `admin`/`admin`.

Also an `intelmq` user with password `intelmq` exists. The default `guest` user only works on localhost.
