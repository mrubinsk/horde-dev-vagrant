#!/usr/bin/env bash

echo 'Creating horde database.'
mysql -u root --password=$MYSQLPASSWORD -e "create database horde";

echo 'Provisioning Horde Groupware.'
mkdir $HORDEDIR

echo "Creating local PEAR install in $HORDEDIR"
pear config-create $HORDEDIR $HORDEDIR/pear.conf
pear -c $HORDEDIR/pear.conf install pear
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf channel-discover pear.horde.org
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf config-set umask 0022
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf config-set -c horde umask 0022

echo 'Setting preferred_state to beta.'
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf config-set preferred_state beta

echo "Running horde_role script and setting horde_dir to $HORDEDIR"
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf install horde/horde_role

# The following is instead of running pear run-scripts horde/horde_role
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf config-set -c horde horde_dir $HORDEDIR

echo 'Performing pear install.'
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf install -a -B horde/webmail

# Needed since we are using separate pear.
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "SetEnv PHP_PEAR_SYSCONF_DIR /var/www/html/horde\nphp_value include_path /var/www/html/horde/pear/php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# Outlook EAS testing requires SSL.
sudo a2enmod ssl

sudo mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
sudo awk '/<VirtualHost/ { print; print "SetEnv PHP_PEAR_SYSCONF_DIR /var/www/html/horde\nphp_value include_path /var/www/html/horde/pear/php"; next}1' /etc/apache2/sites-available/default-ssl.conf.bak > /etc/apache2/sites-available/default-ssl.conf

# Make this available to the installer.
#
export PHP_PEAR_SYSCONF_DIR="$HORDEDIR"

echo 'Restarting Apache.'
/etc/init.d/apache2 restart

echo 'Running webmail-install.'
/vagrant/horde-install.expect

cp /vagrant/conf/horde/* $HORDEDIR/config/
cp /vagrant/conf/ingo/* $HORDEDIR/ingo/config/

#Change the following if Vagrant machine configured to use a different port.
# TODO: utilize an environment variable in the Vagrantfile.
echo -e "\$conf['server']['port'] = 8080;" | sudo tee -a $HORDEDIR/config/conf.php

# Purposely do not include the following in the conf.local.php file since they
# either are, or will be, switchable via vagrant config file.
#TODO configure this?
echo "Enabling EAS support."
cat /vagrant/conf.d/10-eas.php >> $HORDEDIR/config/horde.local.php

# Use IMAP AUTH?
if [ "$IMAP_AUTH" = "true" ]
then
  cat /vagrant/conf.d/10-imapauth.php >> $HORDEDIR/config/horde.local.php
  echo "<?php
\$servers['imap']['hordeauth'] = true;" >> $HORDEDIR/imp/config/backends.local.php
fi

# TODO: Configure switch to include the low memory config or not.
# echo 'Adding low memory configuration for mysql.'
# cp /vagrant/mysqld_low_memory_usage.cnf /etc/mysql/conf.d/mysqld_low_memory_usage.cnf
# /etc/init.d/mysql restart

