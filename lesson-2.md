# Lesson 2: Getting started


## Familiarization with the VM

* how to read the web page on the VM
* Does the internet connection work in the VM?

## Familiarization - where can I find what? A short walk-through the directory structure

First of all, the documentation is pretty solid by now. So if you feel lost - apart from this tutorial, you can find 
the documenation [here](https://github.com/certtools/intelmq/blob/master/docs/User-Guide.md) and the Developers Guide here](https://github.com/certtools/intelmq/blob/master/docs/Developers-Guide.md)

### The directory structure and command line  tools

A "development installation" has been chosen as installation method so that all IntelMQ-installation related files are located in `/opt/intelmq` for a better overview.

* `/opt/intelmq/`: The base location for all IntelMQ core-related files.
* `/opt/intelmq/etc/`: The configuration files.
* `/opt/intelmq/var/lib/`: Data of IntelMQ and it's bots:
* `/opt/intelmq/var/lib/bots/`: For example configuration files of certain bots, local lookup data and output files.
* `/opt/intelmq/var/log/`: The log files and dumped data.
* `/opt/intelmq/var/run/`: The internal PID-files.

### Where can I find the log files?

### intelmqctl

As any other ctl-tool these commands are provided:
* start
* stop
* status
* reload: schedules re-reading and applying configuration without stopping
* restart
These commands take one bot-id as optional parameter. If not given, the command is applied to all configured bots.

Further important commands:
* list queues: Show configured queues and their sizes.
* check: Runs some self-check on IntelMQ and supported bots.
* clear: Clears the queue given as parameter.
* log: Shows the last lines of the bot given as paramter.

These commands are described later:
* enable
* disable

You can get help with `-h` or `--help`, also available for sub-commands. Most subcommands also have auto-completion.

Further commands and documentation can also be found in the [IntelMQ documentation](https://github.com/certtools/intelmq/blob/master/docs/intelmqctl.md)

## Default configuration

A default configuration with some basic bots and public feeds is shipped with IntelMQ and provided in the tutorial VM. It consists of:
* 4 collectors and their respective parsers with public feeds.
* Some experts providing de-duplication and basic lookups, including a round-robin "load-balanced" bot.
* A file output writing to `/opt/intelmq/var/lib/bots/file-output/events.txt`.

In the beginning of the tutorial we will work with this default configuration, afterwards we will set up our own workflows.

### Task: Start a collector and look at it's log

Start the `spamhaus-drop-collector` and verify in the logs that it successfully collected the feed. Then stop the bot again.

### Answer

* Starting: `intelmqctl start spamhaus-drop-collector`
* Looking at the logs:
  * `intelmqctl log spamhaus-drop-collector` or
  * `less var/log/spamhaus-drop-collector.log` or similar
  should give an output like:
```
2020-01-24T11:15:39.023000 - spamhaus-drop-collector - INFO - HTTPCollectorBot initialized with id spamhaus-drop-collector and intelmq 2.1.1 and python 3.7.3 (default, Apr  3 2019, 05:39:12) as process 6950.
2020-01-24T11:15:39.023000 - spamhaus-drop-collector - INFO - Bot is starting.
2020-01-24T11:15:39.024000 - spamhaus-drop-collector - INFO - Bot initialization completed.
2020-01-24T11:15:39.024000 - spamhaus-drop-collector - INFO - Downloading report from 'https://www.spamhaus.org/drop/drop.txt'.
2020-01-24T11:15:39.147000 - spamhaus-drop-collector - INFO - Report downloaded.
2020-01-24T11:15:39.151000 - spamhaus-drop-collector - INFO - Idling for 3600.0s (1h) now.
```
You can see that the INFO log level shows information on startup, the fetched URL and that the bots is then sleeping for one hour.
* Stop the bot: `intelmqctl stop spamhaus-drop-collector`

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



### Task: connect collector abuse.ch_feodo with a file output bot


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

## Configure a feed: 

New feeds can be configured by adding a collector and the matching parser. The [feeds documentation](https://github.com/certtools/intelmq/blob/master/docs/Feeds.md#c2-domains) has a long list of known feeds along with the required configuration parameters. If you know of more feeds, please let us know or [open a pull request](https://github.com/certtools/intelmq/blob/master/docs/Developers-Guide.md#feeds-documentation) to add it!

### Task
Configure the "Bambenek C2 Domains" feed as described [in the documentation](https://github.com/certtools/intelmq/blob/master/docs/Feeds.md#c2-domains) and start the collector and parser.

TODO: not to the output yet.

### Answer
TODO: Copy and paste from the documentation

## Experts: adding information to the stream

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


