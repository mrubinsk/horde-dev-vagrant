#!/usr/bin/env bash

# Install Horde from source
apt-get install -y git
mkdir -p /horde/data
mkdir -p /horde/src

# Clone FRAMEWORK_5_2
git clone --depth 1 https://github.com/horde/horde.git /horde/src

# Needed so we can copy the install_dev.conf file.
chown vagrant:vagrant /horde/src/framework/bin

# Install framework
cp /vagrant/install_dev.conf /horde/src/framework/bin
cp /vagrant/registry.local.php /horde/src/horde/config

/horde/src/framework/bin/pear_batch_install -p ../framework/Role
/horde/src/framework/bin/install_dev

#cp /horde/src/horde/config/conf.php.dist /horde/src/horde/config/conf.php
cp /vagrant/horde-conf.php /horde/src/horde/config/conf.php
cp /vagrant/imp-conf.php /horde/src/imp/config/conf.php
cp /vagrant/imp-backends.local.php /horde/src/imp/config/backends.local/php
cp /vagrant/kronolith-conf.php /horde/src/kronolith/config/conf.php
cp /vagrant/turba-conf.php /horde/src/turba/config/conf.php
#temp
chown www-data:www-data /horde/src/horde/config/conf.php

/horde/src/horde/bin/horde-db-migrate

# Install Horde PEAR packages, so that we don't need to deal with those
# dependencies
#/horde/src/framework/bin/pear_batch_install

# Now install optional/required PEAR/PECL packages
#/horde/src/framework/bin/pear_batch_install \
#	-p .,../content,../gollem,../horde,../imp,../ingo,../kronolith,../mnemo,../nag,../passwd,../timeobjects,../trean,../turba
