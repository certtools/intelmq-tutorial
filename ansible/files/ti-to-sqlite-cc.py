#!/usr/bin/python3
# -*- coding: utf-8 -*-
"""
Created on Mon Jan 20 14:24:23 2020

@author: sebastian
"""

import argparse
import collections
import json
import requests
import sqlite3
import sys


TI_DATABASE_URL = 'https://www.trusted-introducer.org/directory/teams.json'


def parse_ti(data, base):
    base = sqlite3.connect(base)
    cursor = base.cursor()
    cursor.execute('DROP TABLE IF EXISTS ti')
    cursor.execute('CREATE TABLE ti (cc text, email text)')

    countries = collections.defaultdict(list)
    for element in data:
        if 'National' not in element['constituency']['types']:
            continue
#        assert len(element['emails']) == 1
        for cc in element['constituency']['countries']:
            try:
                int(cc['code'])
            except ValueError:
                # type can be a number, ignore them
                # only use the strings
                countries[cc['code']].append(element['emails'][0]['address'])
    for country, emails in countries.items():
        cursor.execute('INSERT INTO ti (cc, email) VALUES (?, ?)',
                       (country, ','.join(emails)))
    base.commit()
    base.close()


def main():
    parser = argparse.ArgumentParser('ti-to-slite-cc',
                                     description='Converts TI database to SQLite, CC only')
    parser.add_argument('--ti', '-i', help="TI database as JSON",
                        type=argparse.FileType('r'))
    # can't use FileType here, as sqlite3 module only understands filenames
    parser.add_argument('outfile', help="File to wite output to.")
    args = parser.parse_args()

    if args.ti:
        ti_database = json.load(args.ti)
    else:
        ti_database = requests.get(TI_DATABASE_URL).json()
    parse_ti(ti_database, args.outfile)


if __name__ == '__main__':
    sys.exit(main())
