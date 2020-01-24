# Lesson 2: Getting started


## Familiarization with the VM

* how to read the web page on the VM

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

Further commands and documentation can also be found in the [IntelMQ documentation]([here](https://github.com/certtools/intelmq/blob/master/docs/intelmqctl.md)

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
  * `intelmqctl log spamhaus-drop-collector` or `less var/log/spamhaus-drop-collector.log` or similar should give an output like:
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

... blabla talk about collectors and parsers



### Task: connect collector abuse.ch_feodo with a file output bot


### Answer


## Input output and filters

Filter on the country code NL

### Task : create a filter and filter on NL

### Answer


## Configure a feed: 


<XXX insert description by sebix XXX>

<comment: use a feed here which does not have country code info so that we can add it in the next task>

### Task : XXX

### Answer


## Experts: adding information to the stream

The file `/opt/intelmq/var/lib/bots/maxmind_geoip/GeoLite2-City.mmdb` contains the free GeoLite2 database.

### Task: add geoip info to the previous feed


### Answer

The bot is the "MaxMind GeoIP Expert". Parameters:
* `database`: `/opt/intelmq/var/lib/bots/maxmind_geoip/GeoLite2-City.mmdb`

## Experts: add IP 2 ASN enrichment

The file `/opt/intelmq/var/lib/bots/asn_lookup/ipasn.dat` contains data downloaded and converted by pyasn's utilities.

### Task

### Answer

The bot is the "ASN Lookup" expert. Parameters:
* `database`: `/opt/intelmq/var/lib/bots/asn_lookup/ipasn.dat`

## The IntelMQ manager

Intro, screenshots, text description. What can it do for you, when is it better to use the cmd line? Etc.

### Task: configure a new feed (filecollector) and start und stop it

### Answer



# Recap


