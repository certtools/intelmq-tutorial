#!/bin/bash

set -e

[ "user" != "$USER" ] && exec sudo -u user $0 "$@"

pushd /home/user/intelmq-tutorial
git pull --rebase origin master
popd

/usr/local/bin/tutorial-to-html.sh
