# Lesson 2: Getting started


## Familiarization with the VM

* how to read the web page on the VM

## Familiarization - where can I find what? A short walk-through the directory structure

First of all, the documentation is pretty solid by now. So if you feel lost - apart from this tutorial, you can find 
the documenation [here] and the Developers Guide here](https://github.com/certtools/intelmq/blob/develop/docs/Developers-Guide.md)

### The directory structure and command line  tools

/opt 

/opt/...

### Where can I find the log files?

### intelmqctl


* start / stop
* check
* ...

### Task: ...


### Answer





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


