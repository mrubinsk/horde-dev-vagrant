#!/usr/bin/env bash

echo 'Creating horde database.'
mysql -u root --password=$MYSQLPASSWORD -e "create database horde";

# Install Horde from source
apt-get install -y git
mkdir -p /horde/data
mkdir -p /horde/src

# Clone Git FRAMEWORK_5_2
git clone -b FRAMEWORK_5_2 --single-branch https://github.com/horde/horde.git  /horde/src


# Needed so we can copy the install_dev.conf file.
chown vagrant:vagrant /horde/src/framework/bin

# Install framework
cp /vagrant/install_dev.conf /horde/src/framework/bin
cp /vagrant/registry.local.php /horde/src/horde/config

/horde/src/framework/bin/pear_batch_install -p ../framework/Role
/horde/src/framework/bin/install_dev

cp /vagrant/horde-conf.php /horde/src/horde/config/conf.php
cp /vagrant/imp-conf.php /horde/src/imp/config/conf.php
cp /vagrant/imp-backends.local.php /horde/src/imp/config/backends.local.php
cp /vagrant/kronolith-conf.php /horde/src/kronolith/config/conf.php
cp /vagrant/turba-conf.php /horde/src/turba/config/conf.php
chown www-data:www-data /horde/src/horde/config/conf.php

#TODO - allow choosing between procmail and sieve easily.
cp /vagrant/ingo-procmail-backends.local.php /horde/src/ingo/config/backends.local.php

/horde/src/horde/bin/horde-db-migrate

# Include hook to automatically set from_addr to username@localhost
if [ "$INCLUDE_HOOKS" = "true" ]
then
    echo "<?php
class Horde_Hooks
{
   public function prefs_init(\$pref, \$value, \$username, \$scope_ob)
   {
      switch (\$pref) {
      case 'from_addr':
           if (is_null(\$username)) {
               return \$value;
           }
           return \$username . '@localhost';
      }
   }

}" >> /horde/src/horde/config/hooks.php
  mkdir /horde/src/horde/config/prefs.d
  cp /vagrant/prefs.d/10-hooks.php /horde/src/horde/config/prefs.d/10-hooks.php
fi


# Install Horde PEAR packages, so that we don't need to deal with those
# dependencies
#/horde/src/framework/bin/pear_batch_install

# Now install optional/required PEAR/PECL packages
#/horde/src/framework/bin/pear_batch_install \
#	-p .,../content,../gollem,../horde,../imp,../ingo,../kronolith,../mnemo,../nag,../passwd,../timeobjects,../trean,../turba
