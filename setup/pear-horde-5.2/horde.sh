#!/usr/bin/env bash

pear channel-discover pear.horde.org
pear install horde/horde_role
pear config-set horde_dir /var/www/html/horde

pear install -a -B horde/webmail


# Install Horde from source

#cp /horde/src/horde/config/conf.php.dist /horde/src/horde/config/conf.php
#cp /vagrant/horde-conf.php /horde/src/horde/config/conf.php

#temp
#chown www-data:www-data /horde/src/horde/config/conf.php

#/horde/src/horde/bin/horde-db-migrate

# Install Horde PEAR packages, so that we don't need to deal with those
# dependencies
#/horde/src/framework/bin/pear_batch_install

# Now install optional/required PEAR/PECL packages
#/horde/src/framework/bin/pear_batch_install \
#	-p .,../content,../gollem,../horde,../imp,../ingo,../kronolith,../mnemo,../nag,../passwd,../timeobjects,../trean,../turba
