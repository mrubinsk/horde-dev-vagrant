#!/usr/bin/env bash

echo 'Provisioning Horde Groupware.'
mkdir /var/www/html/horde

echo "Creating local PEAR install in /var/www/html/horde"
pear config-create /var/www/html/horde /var/www/html/horde/pear.conf
pear -c /var/www/html/horde/pear.conf install pear
/var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf channel-discover pear.horde.org
/var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf config-set umask 0022
/var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf config-set -c horde umask 0022

echo 'Setting preferred_state to beta.'
/var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf config-set preferred_state beta

echo 'Running horde_role script and setting horde_dir to /var/www/html/horde'
/var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf install horde/horde_role
/vagrant/dohorderole.sh

echo 'Performing pear install.'
/var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf install -a -B horde/webmail

echo "Setting include_path into /var/www/html/horde/config/horde.local.php"
echo -e "<?php\nini_set('include_path', '/var/www/html/horde/pear/php' . PATH_SEPARATOR . ini_get('include_path'));" | sudo tee /var/www/html/horde/config/horde.local.php

echo 'Running webmail-install.'
export PHP_PEAR_SYSCONF_DIR=/var/www/html/horde
/vagrant/horde-install.sh

echo -e '$conf['server']['port'] = 8080;' | sudo tee -a /var/www/html/horde/config/conf.php

echo "SetEnv PHP_PEAR_SYSCONF_DIR /var/www/html/horde\n" >> /etc/apache2/apache2.conf
