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
/vagrant/dohorderole.sh

echo 'Performing pear install.'
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf install -a -B horde/webmail

#echo "Setting include_path into $HORDEDIR/config/horde.local.php"
#echo -e "<?php\nini_set('include_path', '$HORDEDIR/pear/php' . PATH_SEPARATOR . ini_get('include_path'));" | sudo tee $HORDEDIR/config/horde.local.php
# Needed since we are using separate pear.
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "SetEnv PHP_PEAR_SYSCONF_DIR /var/www/html/horde\nphp_value include_path /var/www/html/horde/pear/php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# Make this available to the installer.
export PHP_PEAR_SYSCONF_DIR="$HORDEDIR"

echo 'Restarting Apache.'
/etc/init.d/apache2 restart

echo 'Running webmail-install.'
/vagrant/horde-install.sh

echo -e "\$conf['server']['port'] = 8080;" | sudo tee -a $HORDEDIR/config/conf.php
# Include hook to automatically set from_addr to username@localhost
if [ "$INCLUDE_HOOKS" = "true" ]
then
  echo "Creating prefs hooks."
  if [ -f "$HORDEDIR/config/hooks.php" ]
  then
      echo "$HORDEDIR/config/hooks.php already exists, skipping."
  else
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
}" >> $HORDEDIR/config/hooks.php
    cp /vagrant/prefs.d/10-hooks.php $HORDEDIR/config/prefs.d/10-hooks.php
  fi
fi

#TODO - configure this?
if [ -f "$HORDEDIR/config/conf.d/10-cookie.php" ]
then
    echo "$HORDEDIR/config/conf.d/10-cookie.php already exists, skipping."
else
    echo "Setting empty cookie path/domain."
    mkdir $HORDEDIR/config/conf.d
    echo "<?php
\$conf['cookie']['domain'] = '';
\$conf['cookie']['path'] = '/';" >> $HORDEDIR/config/conf.d/10-cookie.php
fi

#TODO - allow choosing between procmail and sieve easily.
cp /vagrant/ingo-procmail-backends.local.php $HORDEDIR/ingo/config/backends.local.php

# TODO: Configure switch to include the low memory config or not.
# echo 'Adding low memory configuration for mysql.'
# cp /vagrant/mysqld_low_memory_usage.cnf /etc/mysql/conf.d/mysqld_low_memory_usage.cnf
# /etc/init.d/mysql restart

