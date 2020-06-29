# Lesson 4: Advanced topics for IntelMQ developers - custom BOTS


How to develop new bots for IntelMQ is described [here](https://intelmq.readthedocs.io/en/latest/Developers-Guide/#bot-developer-guide)

## Motivation


However, the installation of these custom bots can be troublesome as one must modify and add several config files. Whenever bots get changes, the evolution of these bots can mean further adding or removing additional parameters.
In such cases the configurations needs be adapted, or the bot may not run. 

To ease this effort, the tools residing in the repository [IntelMQ Tools](https://github.com/jhemp/intelmq-tools) provide functionality to verify and update configurations and also to add or remove such custom bots.

In short: they make your life easier as an IntelMQ bot developer.

# Installation

These tools can be installed independently from IntelMQ. The simplest way is to clone the repository on your local system can adapt the configuration file to your needs.

## Task: Download and configuration of the Tool

Clone the repository https://github.com/jhemp/intelmq-tools in the home folder of the root user.


```bash
$ git clone https://github.com/jhemp/intelmq-tools
```

Create the initial configuration file

```bash
~ $ cd intelmq-tool
~/intelmq-tools $ cp config/config.ini_tmpl config/config.ini
```

Open the newly created `config.ini` in an editor and set the values as your instance of IntelMQ is configured

For a normal installation of IntelMQ the following settings can be used

```
intelMQLocation=/lib/python3.6/site-packages/intelmq/bots
entryPointsLocation=/lib/python3.6/site-packages/intelmq-2.1.1-py3.6.egg-info/entry_points.txt
binFolder=/usr/bin
```
(note that your python path might be different, please adjust accordingly).


# Tools

The tool provides several subtools. The following sections will describe them.

##  Details of IntelMQ

The `-d` flag shows details of the installation.

```bash
~/intelmq-tools $ ./intelmq_tools.py -d
IntelMQ Installation Directory: /intelmq
IntelMQ Version:                2.2.1
Configuration Directory:        /opt/intelmq/etc/
running BOTS File location:     /opt/intelmq/etc/BOTS
default BOTS File location:     /intelmq/intelmq/bots/BOTS
defaults.conf location:         /opt/intelmq/etc/defaults.conf
runtime.conf location:          /opt/intelmq/etc/runtime.conf
Custom IntelMQ Bots location    /bots
```

##  List Bots (`list` command)


```bash
~/intelmq-tools $ ./intelmq_tools.py list -o
BOT Type:                Collector
BOT Class:               AlienVault OTX
Description:             AlienVault OTX Collector is the bot responsible to get the report through the API. Report could vary according to subscriptions.                                                                                                                                       
Module:                  intelmq.bots.collectors.alienvault_otx.collector
Entry Point:             intelmq.bots.collectors.alienvault_otx.collector:BOT.run
File:                    /intelmq/bots/collectors/alienvault_otx/collector.py
Running Instances        0

....
```

The listing offers several different methods to show bots

Lists bots

optional arguments:
  --verbose, -v
  -f, --full         display full
  --dev              Development
  -h, --help         show this help message and exit
  -o, --original     List all original BOTS
  -i, --installed    List all installed BOTS
  -c, --customs      List all custom BOTS
  -u, --uninstalled  List all not installed BOTS
  -l, --list         List all BOTS


##  Check configuration

The check tool compares the different configurations and displays the found differences.

```bash
~/intelmq-tools $  ./intelmq_tools.py check -r
BOT Class:         Deduplicator
BOT Instance Name: deduplicator-expert
----------------------------------------
    Running Configuration is missing keys: ['redis_cache_password']
----------------------------------------

BOT Class:         Cymru Whois
BOT Instance Name: cymru-whois-expert
----------------------------------------
    Running Configuration is missing keys: ['overwrite']
----------------------------------------

BOT Class:         url2fqdn
BOT Instance Name: url2fqdn-expert
----------------------------------------
    Running Configuration has more keys:   ['load_balance']
----------------------------------------

BOT Class:         File
BOT Instance Name: file-output
----------------------------------------
    Running Configuration is missing keys: ['encoding_errors_mode', 'format_filename', 'keep_raw_field', 'message_jsondict_as_string', 'message_with_type']
----------------------------------------

```
Check tool offers the following options-

optional arguments:
  --verbose, -v
  -f, --full     display full
  --dev          Development
  -h, --help     show this help message and exit
  -b, --bots     Check if the running BOTS configuration and the original configuration.
  -r, --runtime  Check if parameters of BOTS configuration matches the runtime one. Note: Compares Running BOTS file with running.conf.



  
  
##  Fixing configurations

The fix tool can fix the found isses and depending on the issue auto fix it.


```bash
~/intelmq-tools $ ./intelmq_tools.py fix -a -r
Note: Parameter values will not be changed!

Fixing runtime.conf File
Fixing deduplicator-expert:
Adding Key redis_cache_password to Parameter parameters with default value None
Fixing cymru-whois-expert:
Adding Key overwrite to Parameter parameters with default value False
Fixing url2fqdn-expert:
Removing Key load_balance from Parameter parameters
Fixing file-output:
Adding Key encoding_errors_mode to Parameter parameters with default value strict
Adding Key format_filename to Parameter parameters with default value False
Adding Key keep_raw_field to Parameter parameters with default value False
Adding Key message_jsondict_as_string to Parameter parameters with default value False
Adding Key message_with_type to Parameter parameters with default value False

```

Tool for fixing bot configurations

optional arguments:
  --verbose, -v
  -f, --full     display full
  --dev          Development
  -h, --help     show this help message and exit
  -a, --auto     Automatic fixing. NOTE: Only configuration keys are considered.
  -b, --bots     Check if the running BOTS configuration and the original configuration.
  -r, --runtime  Fixes parameters of BOTS configuration matches the runtime  one. Note: Compares Running BOTS file with running.conf.
  --version      show program's version number and exit



##  Installation / Uninstallation of custom BOTS

The tool offers the feature to install and uninstall custom bots with ease. The tool creates all the required files and entries in IntelMQ four you.


Tool for installing bots

```bash
optional arguments:
  --verbose, -v
  -f, --full            display full
  --dev                 Development
  -h, --help            show this help message and exit
  -i INSTALL, --install INSTALL
                        Path of the bot to install (Note: Module Folder only)
  -u UNINSTALL, --uninstall UNINSTALL
                        Path of the bot to uninstall (Note: Module Folder
                        only)
  --version             show program's version number and exit
```

### Task: Installing a Bot

To install a bot one needs only to specify its main file.

```bash
~/intelmq-tools $  ./intelmq_tools.py install --dev -i bots/parsers/exampleparser/parser.py 
File /home/jpweber/workspace/intelmq-bots/fake-install/usr/bin/intelmq.bots.parsers.exampleparser.parser created
Directory /home/jpweber/workspace/intelmq-bots/fake-install/intelmq/intelmq/bots/parsers/exampleparser was created
BOT Class ExampleBOT was successfully inserted

```

