#!/usr/bin/env bash

echo 'Provisioning MariaDB server.'
apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db
add-apt-repository 'deb http://mirror.jmu.edu/pub/mariadb/repo/5.5/ubuntu trusty main'
apt-get update

debconf-set-selections <<< "mysql-server mysql-server/root_password password $MYSQLPASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $MYSQLPASSWORD"

apt-get -y install mariadb-server