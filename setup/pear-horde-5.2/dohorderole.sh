#!/usr/bin/expect
spawn /var/www/html/horde/pear/pear -c /var/www/html/horde/pear.conf run-scripts horde/horde_role
expect "Filesystem location for the base Horde application :"
send "/var/www/html/horde\r"
expect eof
