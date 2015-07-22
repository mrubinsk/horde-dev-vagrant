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

echo 'Running horde_role script and setting horde_dir to $HORDEDIR'
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf install horde/horde_role
/vagrant/dohorderole.sh

echo 'Performing pear install.'
$HORDEDIR/pear/pear -c $HORDEDIR/pear.conf install -a -B horde/webmail

echo "Setting include_path into $HORDEDIR/config/horde.local.php"
echo -e "<?php\nini_set('include_path', '$HORDEDIR/pear/php' . PATH_SEPARATOR . ini_get('include_path'));" | sudo tee $HORDEDIR/config/horde.local.php

echo 'Running webmail-install.'
export PHP_PEAR_SYSCONF_DIR=$HORDEDIR
/vagrant/horde-install.sh

echo -e '$conf['server']['port'] = 8080;' | sudo tee -a $HORDEDIR/config/conf.php

echo "SetEnv PHP_PEAR_SYSCONF_DIR $HORDEDIR\n" >> /etc/apache2/apache2.conf

# Include hook to automatically set from_addr to username@localhost
echo "Creating prefs hooks."
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
