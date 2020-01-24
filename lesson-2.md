# Lesson 2: Getting started


## Familiarization with the VM: makeing sure it works

* How to read the tutorial web page on the VM
* Does the internet connection work in the VM?

### Answer

It depends on how you configured your VirtualBox VM. The default network setup in VirtualBox is "NAT". Meaning, your VM is NATed to your PC. That means, your PC can reach the VM via port forwarding. The default config in the VM image (.ova) is that we forward the port 8080 on your PC/laptop to the VM port 80. See the screenshot below.

![port forwarding setup](images/vm-network-port-forwarding.png)

This being said, your setup might be slightly different (you might have decided to bridge and the VM received an IP address via DHCP. Please check the IP address inside of your VM in this case).

We now assume, you followed the default approach of the VM and used the portforwarding localhost:8080 -> VM:80 approach.
Now go to [http://localhost:8080/](http://localhost:8080/).

You should see a small website like: 

![VM landing page](images/vm-landing-page.png)

Finally, we need to make sure, that the VM can download data from the Internet.
Please execute a `ping 8.8.8.8` or similar and make sure that DNS resolving works:

```bash
ping www.google.com
```


## Familiarization - where can I find what? A short walk-through the directory structure

After making sure that we can reach the VM from the host (your PC or laptop), we can take a look at the VM's setup.

But first let us say that the documentation is pretty solid by now. So if you feel lost - apart from this tutorial, you can find 
the documenation [here](https://github.com/certtools/intelmq/blob/master/docs/User-Guide.md) and the [Developers Guide here](https://github.com/certtools/intelmq/blob/master/docs/Developers-Guide.md)

### The directory structure and command line  tools

IntelMQ knows multiple ways of getting installed: .deb packages, .rpm, or via pip or via git clone. Also, we distinguish between a production installation and a development installation.

In our case, a development installation has been chosen as installation method so that all IntelMQ-installation related files can be found in `/opt/intelmq` for a better overview (if you had a Debian default install, config files would end up in /etc/intelmq/, etc.).

Directory layout:

* `/opt/intelmq/`: The base location for all IntelMQ core-related files.
* `/opt/intelmq/etc/`: The configuration files.
* `/opt/intelmq/var/lib/`: Data of IntelMQ and it's bots:
* `/opt/intelmq/var/lib/bots/`: For example configuration files of certain bots, local lookup data and output files.
* `/opt/intelmq/var/log/`: The log files and dumped data.
* `/opt/intelmq/var/run/`: The internal PID-files.


#### Task: Where can I find the log files?

#### Answer: `/opt/intelmq/var/log`


### intelmqctl

IntelMQ comes with a command line tool, called `intelmqctl`. It is the work-horse for interacting with IntelMQ. Therefore, we would like to make you familiar with it first. As in many other command line tool (compare for example the `apache2ctl` tool), these commands are provided:

* `intelmqctl start`
* `intelmqctl stop`
* `intelmqctl status`
* `intelmqctl reload`: schedules re-reading and applying configuration without stopping
* `intelmqctl restart`

These commands take a `bot-id` as optional parameter. If not given, the command is applied to all configured bots.

Other important commands:

* `intelmqctl list queues`: Show configured queues and their sizes.
* `intelmqctl check`: Runs some self-check on IntelMQ and supported bots.
* `intelmqctl clear`: Clears the queue given as parameter.
* `intelmqctl log`: Shows the last lines of the bot given as paramter.

These commands are described later:
* `intelmqctl enable`
* `intelmqctl disable`

You can get help with `intelmqctl -h` or `intelmqctl --help`, also available for sub-commands. Most subcommands also have auto-completion.

A complete list of  available commands can  be found in the [IntelMQctl documentation](https://github.com/certtools/intelmq/blob/master/docs/intelmqctl.md)

## Default configuration

This tutorial (and in fact every default installation of IntelMQ) comes with a very basic default configuration: some basic bots and public feeds. By *configuration* we mean:

* all parameters for all bots (for example API-keys, database names, database users, mail server address, etc.) 
* the *pipeline* configuration (which bot is connected to which other bot)
* default settings which should apply to all bots.

In our case, the default config consists of:

* 4 collectors and their respective parsers with public feeds.
* Some experts providing de-duplication and basic lookups, including a round-robin "load-balanced" bot.
* A file output bot writing to `/opt/intelmq/var/lib/bots/file-output/events.txt`.

In the beginning of the tutorial we will work with this default configuration, afterwards we will set up our own workflows.

### Task: Start a collector and look at it's log

Start the `spamhaus-drop-collector` and verify in the logs that it successfully collected the feed. Then stop the bot again.

### Answer

The bot-id for the  `spamhaus-drop-collector` is... you might have guess it...  `spamhaus-drop-collector`.

* Here is how you start it: `intelmqctl start spamhaus-drop-collector`
* Here is how you look at its logs:
  * `intelmqctl log spamhaus-drop-collector` or (even simpler) `cd /opt/intelmq; less var/log/spamhaus-drop-collector.log`  should show you the log file:
```
2020-01-24T11:15:39.023000 - spamhaus-drop-collector - INFO - HTTPCollectorBot initialized with id spamhaus-drop-collector and intelmq 2.1.1 and python 3.7.3 (default, Apr  3 2019, 05:39:12) as process 6950.
2020-01-24T11:15:39.023000 - spamhaus-drop-collector - INFO - Bot is starting.
2020-01-24T11:15:39.024000 - spamhaus-drop-collector - INFO - Bot initialization completed.
2020-01-24T11:15:39.024000 - spamhaus-drop-collector - INFO - Downloading report from 'https://www.spamhaus.org/drop/drop.txt'.
2020-01-24T11:15:39.147000 - spamhaus-drop-collector - INFO - Report downloaded.
2020-01-24T11:15:39.151000 - spamhaus-drop-collector - INFO - Idling for 3600.0s (1h) now.
```

(note that your output might vary slightly).

You can see that the INFO log level shows information on startup, the fetched URL and that the bots is then sleeping for one hour.

* Stopping the bot: `intelmqctl stop spamhaus-drop-collector`

### Lookup how many events are in the queue for a bot.

Start the `spamhaus-drop-collector` and look up how many events are waiting to be processed in the queue of the next bot (`deduplicator-expert`).

### Answer

* `intelmqctl start spamhaus-drop-parser`
* `intelmqctl list queues -q` shows all non-empty queues, for example:
```
deduplicator-expert-queue - 807
```

## Simple input and output bots

TODO: talk about collectors and parsers



### Task: connect the abuse.ch_feodo collector bot with a file output bot


### Answer


## Input output and filters

Filter on the country code NL


### Task : filter data on country

The Feodo tracker by abuse.ch provides some feeds, the [HTML "feed"](https://feodotracker.abuse.ch/browse/) provides the most information for the C&C server IP addresses including the country and the malware.

Filter the data of the "Feodotracker Browse" feed on country Netherlands (country code "NL") and write the output to `/opt/intelmq/var/lib/bots/file-output/feodo-nl.txt`.

### Answer

Create a "Filter" expert and filter for `"source.geolocation.cc"` = `"NL"`.

#### Detailed answer

filter expert:
* `filter_key`: `source.geolocation.cc`
* `filter_value`: `NL`

New feeds can be configured by adding a collector and the matching parser. The [feeds documentation](https://github.com/certtools/intelmq/blob/master/docs/Feeds.md#c2-domains) has a long list of known feeds along with the required configuration parameters. If you know of more feeds, please let us know or [open a pull request](https://github.com/certtools/intelmq/blob/master/docs/Developers-Guide.md#feeds-documentation) to add it!

### Task
Configure the "Bambenek C2 Domains" feed as described [in the documentation](https://github.com/certtools/intelmq/blob/master/docs/Feeds.md#c2-domains) and start the collector and parser.

TODO: not to the output yet.

### Answer

TODO: Copy and paste from the documentation


## Experts: adding information to the stream

The file `/opt/intelmq/var/lib/bots/maxmind_geoip/GeoLite2-City.mmdb` contains the free GeoLite2 database.

### Task: add geoip info to the previous feed

Geolocation information is crucial to determine how to act on received data.
The file `/opt/intelmq/var/lib/bots/maxmind_geoip/GeoLite2-City.mmdb` contains the free GeoLite2 database.

Add a geolocation lookup bot to your pipeline and run it and all subsequent bots to see the data in the file.

### Answer

The bot is the "MaxMind GeoIP Expert". The only necessary parameter is:
* `database`: `/opt/intelmq/var/lib/bots/maxmind_geoip/GeoLite2-City.mmdb`

TODO: How to check

## Experts: add IP 2 ASN enrichment

The file `/opt/intelmq/var/lib/bots/asn_lookup/ipasn.dat` contains data downloaded and converted by pyasn's utilities.

### Task

### Answer

The bot is the "ASN Lookup" expert. Parameters:
* `database`: `/opt/intelmq/var/lib/bots/asn_lookup/ipasn.dat`

## The IntelMQ manager

Intro, screenshots, text description. What can it do for you, when is it better to use the cmd line? Etc.

### Task: configure a new feed from local files


### Task: configure a new feed (filecollector) and start und stop it

Fetch `*.csv` files from `/opt/dev_intelmq/intelmq/tests/bots/parsers/shadowserver/testdata/` and connect it with the Shadowserver parser and this with the deduplicator.
Save the configuration.
Start the both newly added bots.


### Answer

Parameters for the "File" collector:
* `delete_file`: `false`
* `path`: `/opt/dev_intelmq/intelmq/tests/bots/parsers/shadowserver/testdata/`
* `postfix`: `.csv`
* `provider`: `Shadowserver`

Parameters for the "ShadowServer" parser:
* `feedname`: not needed, the exact feed will be determined from the file name
* `overwrite`: `true`: this will set the `feed.name` field properly

# Recap


