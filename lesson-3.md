# Lesson 3: Advanced usage of IntelMQ

## (theory): which other bots exist (collectors, parsers, enrichers, output) and where to read about them

## Scheduled bots

All the previously used collector bots use rate limiting: They are active once for fetching data and then idle for the configured time (for example one day).
However it is also possible to use "scheduled" bots. They differ in their behavior:

* They are "disabled" and not started by default (on `intelmqctl start`)
* After starting them explicitly with `intelmqctl start my-scheduled-bot` they run once and then stop.

In the runtime configuration there are two switches for all bots in order to achieve this behavior:
* `enabled`: A boolean, behaves similar to systemd's enabled and disable states. This setting could also be called "autostart". The commands `intelmqctl enable my-bot` and `intelmqctl disable my-bot`, respectively, change this setting.
* `run_mode`: either `continuous` or `scheduled`, the first is the default. The scheduled bots stop directly after running.

Bots with this settings can be started by e.g. cron or systemd timers in regular intervals:

```
# start my-scheduled-bot every day at 6:20
20 6 * * * /usr/local/bin/intelmqctl start my-scheduled-bot
```

### Task: configure a file collector so that it fetches every 5 minutes. Observe in the log files that it was running

TODO

### Answer



## PostgreSQL DB and DB output

### Task: configure an output bot when sends to the (pre-configured) Postgres DB.

The installed PostgreSQL has an user `intelmq` with password `intelmq`, you can connect via IPv4 and IPv6 locally on port 5432 without SSL.
Further, connecting via socket (and `psql` on the command line), every connection is trusted.
The database `intelmq` contains a table `events` with the same schema as .

Re-run the botnet or any part of it and observe that data was sent to postgresql. Instructions how the data can be fetched are below.

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

### Looking at the database

#### With psql

```bash
psql intelmq intelmq
```

As the table has a lot of columns, here is an example SQL query which selects only a few columns:
```sql
SELECT "time.source", "feed.name", "classification.taxonomy", "classification.type", "classification.identifier", "source.asn", "source.network", "source.ip", "source.fqdn", "source.reverse_dns", "source.geolocation.cc" FROM events;
```

To select some statistics:
```sql
SELECT extract(day from "time.source") AS day, "feed.name", "classification.type" FROM events GROUP BY day, "feed.name", "classification.type";
```

#### With fody

Go to the installed fody interface at [`/stats`](http://localhost:8080/stats). You see a query interface which allows you to easily add a lot of "WHERE" clauses without writing actual SQL. In the first two rows you can select on the `time.source` column, the default is the last month. If the value is left empty, it is ignored.
The "Resoulution" field and "View Stats" buttons can be ignored for only fetching data.

## Web-input (one-shot)

The webinput interface available at [`/webinput/`](http://localhost:8080/webinput) allows interactive insertion of any CSV file into your IntelMQ instance.

It consists of two views/steps: The upload and the preview.

In the upload view you provide the data, either as file upload or as copy-pasted file. The "Parser Configuration" allows setting how the CSV should be parsed.

The preview shows the CSV data as table and to the left some settings. The table header shows drop-down menus offering auto-completion to assign IntelMQ fields to the columns. The second row is a simple check-mark if the column should be used or not.

On the left you can do some settings:
* the default timezone, applied to time-columns if the fields do not already have timezone information
* dry run: If true, all classification fields are set to "test". Un-tick the box when submitting data that should be processed.
* classification type: As this is a fixed list, you can use the value from a fixed list. The resulting taxonomy is shown to you.
* classification identifier: a free text (this field is added by a configuration option).

Hint: "constant fields" can be added in the configuration of the webinput.

The button "Refresh Table" causes the backend to parse the data according to the selected fields. Any not valid fields are shown in red and a summary is shown in the top left corner. If you detect any wrong mappings, you can adjust your settings. All rows containing any non-valid data are considered as "failed" and cannot be processed by IntelMQ.

"Submit" will insert the data into the queue defined in the configuration. The Alert box shows if it works and how many rows have been inserted.

### Task: copy & paste example data into supplied web-input GUI

```csv
time,address,malware,additional info
# you need to skip this line`
2020-01-22T23:12:24+02,10.0.0.1,zeus,very bad!!!
2020-01-23T04:34:46+02,10.0.0.2,smokeloader,no further information available
2020-01-24T15:52:05,10.0.0.3,spybot,"not, my, department!"
2020-01-25T82:12:24+02,10.0.0.4,android.nitmo,huh?
```

Observe that the valid data is in Postgresql

### Answer

The necessary settings on the upload are:
* delimiter: `,`
* quotechar: `"` (default)
* escapechar: `\` (default)
* has header: yes
* skip initial space: no (default)
* skip initial N lines: 1
* Show N lines maximum in preview: anything above 4 (default)

In the preview, the columns assignments are:
* `time.source`
* `source.ip`
* `malware.name`
* for example `event_description.text`

Settings:
* timezone: `+02:00`, for the line without time zone information.
* classification type: `infected-system`
* classification identifier: for example `malware`

The fourth line is invalid (bad timestamp).

On submission, the box should say "Successfully processed 3 lines.".

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

## Basic SMTP

An SMTP server is running on localhost Port 25 without authentication. A webmail client is running at http://localhost:8080/webmail/ login is possible for example as `user@localhost`/`user` or `intelmq@localhost`/`intelmq`. `user` is a catchall for any non-existing mail addresses, including all domains.

TODO: Add task

## RabbitMQ
First start the RabbitMQ server:
```bash
sudo systemctl start rabbitmq-server.service
```
The management interface is available at port 15672, you can login with the credentials `admin`/`admin`.

TODO: Add task

## Interfacing with a ticket system

### mail-gen (theory)

### Briefly talk about how CERT.at does it (squelcher + intelmqcli) (theory)


## Overview ecosystem (theory)

### mail-gen

### Fody

### malwarenames mapping

### stats portal, constituency portal


