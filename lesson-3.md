# Lesson 3: Advanced usage of IntelMQ

## Which other bots exist (collectors, parsers, enrichers, output) and where to read about them

The documentation for all bots can be found in the [Bots.md](https://github.com/certtools/intelmq/blob/master/docs/Bots.md) file.
In this lesson, you will need the documentation several times, so better keep it open!

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

To make a bot "scheduled", apply these two settings:
* `enabled`: `false`
* `run_mode`: `scheduled`
These settings are not "parameters" as the other normal parameters you applied until now. In the `runtime.conf` these settings are on the same level as `module` and others.

### Task: configure a scheduled bot

Configure the previously added file collector for for shadowserver data as scheduled bot.

Start it manually to check if the bot correctly stops after the run.

Configure cron to run this bot every 5 minutes. Make sure the crontab contains the following line (the provided VM has):
```
PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games
```

Observe in the log file that it was running. In case of errors, cron will also send you an email.

<details>
    <summary>Click to see the answer.</summary>

#### Answer

* `intelmqctl start shadowserver-file-collector` (depending on which ID you gave your bot)
* Run `crontab -e` and add at the end of the file:
```
*/5 * * * * /usr/local/bin/intelmqctl start shadowserver-file-collector
```
* Check the logs: `tail -f /opt/intelmq/var/log/shadowserver-file-collector.log`
</details>

## PostgreSQL DB and DB output

### Task: configure an output bot when sends to the (pre-configured) Postgres DB.

The installed PostgreSQL has an user `intelmq` with password `intelmq`, you can connect via IPv4 and IPv6 locally on port 5432 without SSL.
Further, connecting via socket (and `psql` on the command line), every connection is trusted.
The database `intelmq` contains a table `events` with the same schema as .

Add an output bot for postgresql in parallel to the file-output.

Re-run the botnet or any collector and observe that data was sent to postgresql. Instructions how the data can be fetched are below.

<details>
    <summary>Click to see the answer.</summary>

#### Answer

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
</details>

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

Observe that the valid data is in the PostgreSQL database.

<details>
    <summary>Click to see the answer.</summary>

#### Answer

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
</details>

## Starting bots interactively

To have a look what bots actually do and for testing purposes it is often useful to start bots in foreground with detailed logging.
This is what `intelmqctl run` is for. Details can be found in the documenation of [intelmqctl](https://github.com/certtools/intelmq/blob/master/docs/intelmqctl.md#run) and with `intelmqctl run -h`. `-h` or `--help` are also available for the various subcommands.

Found out how you can check what country the IP address `131.130.254.77` is in, according to the previously configured MaxMind Geolocation lookup bot.
But do not actually insert this data to the processing pipeline of IntelMQ.

Hint: The above IP address is represented in IntelMQ as `{"source.ip": "131.130.254.77"}`

<details>
    <summary>Click to see the answer.</summary>

### Answer

```
intelmq@malaga:~$ intelmqctl run MaxMind-GeoIP-Expert process -m '{"source.ip": "131.130.254.77"}' -d -s
Starting MaxMind-GeoIP-Expert...
MaxMind-GeoIP-Expert: GeoIPExpertBot initialized with id MaxMind-GeoIP-Expert and intelmq 2.1.1 and python 3.7.3 (default, Apr  3 2019, 05:39:12) as process 22983.
MaxMind-GeoIP-Expert: Bot is starting.
MaxMind-GeoIP-Expert: Bot initialization completed.
MaxMind-GeoIP-Expert:  * Message from cli will be used when processing.
MaxMind-GeoIP-Expert:  * Dryrun only, no message will be really sent through.
MaxMind-GeoIP-Expert: Processing...
[
    {
        "source.geolocation.cc": "AT",
        "source.geolocation.city": "Vienna",
        "source.geolocation.latitude": 48.2006,
        "source.geolocation.longitude": 16.3672,
        "source.ip": "131.130.254.77"
    }
]
MaxMind-GeoIP-Expert: DRYRUN: Message would be sent now to '_default'!
MaxMind-GeoIP-Expert: DRYRUN: Message would be acknowledged now!
```
(your output might vary slightly).

The country is Austria, actually this is the IP address of `cert.at`.

</details>

## Looking up contact data from a local database

`/opt/intelmq/var/lib/bots/sql/ti-teams.sqlite` contains a table `ti` with two columns:
`cc` with two-letter country-codes and `email` with a comma-separated list of email addresses
The data is from TI and contains all national CERTs listed there.

### Task:
Configure a bot so that all data (with country information) gets the national's CERT addresses as `source.abuse_contact`.

<details>
    <summary>Click to see the answer.</summary>

#### Answer

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

</smtp>

## Basic SMTP

An SMTP server is running on localhost Port 25 without authentication. A webmail client is running at http://localhost:8080/webmail/ login is possible for example as `user@localhost`/`user` or `intelmq@localhost`/`intelmq`. `user` is a catchall for any non-existing mail addresses, including all domains.

Hint: The default configuration for the SMTP Bot has STARTTLS set to true, which is not supported by the local mailserver.

### Send data to a local recipient

Configure the SMTP Output so that it sends events to abuse contact as fetched by the previously configured bot.

<details>
    <summary>Click to see the answer.</summary>

#### Answer

* `fieldnames`: As you like, for example `time.source,feed.name,classification.taxonomy,classification.type,classification.identifier,source.asn,source.network,source.ip,source.fqdn,source.reverse_dns,source.geolocation.cc"`
* `mail_from`: As you like, for example `intelmq@localhost`
* `mail_to`: `{ev[source.abuse_contact]}`
* `smtp_host`: `localhost`
* `smtp_password`: `null`
* `smtp_port`: 25
* `smtp_username`: `null`
* `ssl`: `false`
* `starttls`: `false`
* `subject`: As you like
* `text`: As you like

</details>

## RabbitMQ

RabbitMQ can be used as Messaging Queue instead of Redis. How this switch can be made can be found in the [User-Guide](https://github.com/certtools/intelmq/blob/master/docs/User-Guide.md#amqp-beta)

First start the RabbitMQ server:
```bash
sudo systemctl start rabbitmq-server.service
```
The management interface is available at port 15672, you can login with the credentials `admin`/`admin`. You will see the queues, their sizes and statistics after IntelMQ has been started.

Stop the IntelMQ botnet: `intelmqctl stop`

In `/opt/intelmq/etc/defaults.conf` set these parameters:
* `"source_pipeline_broker"` to `"amqp"`
* `"destination_pipeline_broker"` to `"amqp"`
* `"source_pipeline_port"` to `5672` or remove it (the default for amqp kicks in then)
* `"destination_pipeline_port"` to `5672` or remove it (the default for amqp kicks in then)

Now you can start the IntelMQ botnet again: `intelmqctl start`

In the RabbitMQ webinterface watch the statistics of the queues.

## Interfacing with a ticket system

### mail-gen (theory)

### Briefly talk about how CERT.at does it (squelcher + intelmqcli) (theory)


## Overview ecosystem (theory)

### mail-gen

### Fody

### malwarenames mapping

### stats portal, constituency portal


