#!/usr/bin/env bash
if [ "$INSTALL_HORDE" = false ]
then
  exit 1
fi

echo 'Creating horde database.'
mysql -u root --password=$MYSQLPASSWORD -e "create database horde";

# Install Horde from source
apt-get install -y git
mkdir -p /horde/data
mkdir -p /horde/src

# Clone Git master
if [ "$GIT_DEPTH" = "shallow" ]
then
    git clone --depth 1 https://github.com/horde/horde.git /horde/src
else
    git clone https://github.com/horde/horde.git /horde/src
fi

# Needed so we can copy the install_dev.conf file.
chown vagrant:vagrant /horde/src/framework/bin

# Move prebuilt configuration over.
echo 'Copying configuration files.'
cp /vagrant/horde-conf.php /horde/src/horde/config/conf.php
cp /vagrant/imp-conf.php /horde/src/imp/config/conf.php
cp /vagrant/imp-backends.local.php /horde/src/imp/config/backends.local.php
cp /vagrant/kronolith-conf.php /horde/src/kronolith/config/conf.php
cp /vagrant/turba-conf.php /horde/src/turba/config/conf.php
cp /vagrant/turba-backends.local.php /horde/src/turba/config/backends.local.php
cp /vagrant/mnemo-conf.php /horde/src/mnemo/config/conf.php
cp /vagrant/nag-conf.php /horde/src/nag/config/conf.php
chown www-data:www-data /horde/src/horde/config/conf.php

# Install framework
echo 'Linking Horde into webroot.'
cp /vagrant/install_dev.conf /horde/src/framework/bin
cp /vagrant/registry.local.php /horde/src/horde/config
/horde/src/framework/bin/pear_batch_install -p ../framework/Role
/horde/src/framework/bin/install_dev

echo 'Migrating Horde database.'
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
  echo -e "<?php\n\$_prefs['from_addr']['hook'] = true;" >> /horde/src/horde/config/prefs.local.php
fi