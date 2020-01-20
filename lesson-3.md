# Lesson 3: Advanced usage of IntelMQ

## (theory): which other bots exist (collectors, parsers, enrichers, output) and where to read about them

## Scheduled bots

run_modes

### Task: configure a file collector so that it fetches every 5 minutes. Observe in the log files that it was running

### Answer



## PostgreSQL DB and DB output

### Task: configure an output bot when sends to the (pre-configured) Postgres DB.

The installed PostgreSQL has an user `intelmq` with password `intelmq`, you can connect via IPv4 and IPv6 locally on port 5432 without SSL.
Further, connecting via socket (and `psql` on the command line), every connection is trusted.
The database `intelmq` contains a table `events` with the same schema as .

Re-run the botnet, observe that data was sent to postgresql and that you can SELECT * it

### Answer

Configuration parameters for the bot:
* `autocommit`: `true` (default)
* `database`: `intelmq`
* `engine`: `postgresql`
* `host`: `localhost`
* `jsondict_as_string`: `true` (default)
* `password`: `intelmq`
* `port`: `5432`
* `sslmode`: `allow` (no TLS available)
* `table`: `events`
* `user`: `intelmq`



## Web-input (one-shot)

### Task: copy & paste example data into supplied web-input GUI

Observe that the data is in Postgresql


### Answer


## Looking up contact data from a local database

`/opt/intelmq/var/lib/bots/sql/ti-teams.sqlite` contains a table `ti` with two columns:
`cc` with two-letter country-codes and `email` with a comma-separated list of email addresses
The data is from TI and contains all national CERTs listed there.

### Task:
Configure a bot so that all data (with country information) gets the national's CERT addresses as `source.abuse_contact`.

### Answer:

The bot is the "Generic DB Lookup" Expert.
* `database`: `/opt/intelmq/var/lib/bots/sql/ti-teams.sqlite`
* `engine`: `sqlite`
* `host`: not relevant
* `match_fields`: `{"source.geolocation.cc": "cc"}`
* `overwrite`: `true`
* `password`: not relevant
* `port`: not relevant
* `replace_fields`: `{"email": "source.abuse_contact"}`
* `sslmode`: not relevant
* `table`: `ti`
* `user`: not relevant

## Interfacing with a ticket system

### mail-gen (theory)

### Briefly talk about how CERT.at does it (squelcher + intelmqcli) (theory)


## Overview ecosystem (theory)

### mail-gen

### Fody

### malwarenames mapping

### stats portal, constituency portal


