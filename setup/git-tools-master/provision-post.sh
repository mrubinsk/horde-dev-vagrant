#!/usr/bin/env bash

set -ex

if [ -e /vagrant/horde.sql ]; then
  sudo -u vagrant -- mysql -u root --password=$MYSQLPASSWORD < /vagrant/horde.sql
fi
