#!/usr/bin/env bash

pear channel-discover pear.horde.org
pear install horde/horde_role
pear config-set horde_dir /var/www/html/horde

pear install -a -B horde/webmail

