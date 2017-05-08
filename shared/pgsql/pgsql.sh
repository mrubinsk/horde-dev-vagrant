#!/usr/bin/env bash

echo 'Provisioning Postgresql server.'
apt-get install -y postgresql postgresql-contrib
sudo -u postgres createuser horde


