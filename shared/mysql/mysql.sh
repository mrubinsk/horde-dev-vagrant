#!/usr/bin/env bash

echo 'Provisioning MySQL server.'
debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQLPASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQLPASSWORD"
apt-get install -y mysql-server-5.5

