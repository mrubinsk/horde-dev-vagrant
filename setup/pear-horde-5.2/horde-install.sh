#!/usr/bin/expect
set env(PHP_PEAR_SYSCONF_DIR) /var/www/html/horde
spawn php -d include_path=/var/www/html/horde/pear/php /var/www/html/horde/pear/webmail-install
expect {Type your choice \[\]:}
send "mysql\r" 
expect {Username to connect to the database as* \[\]}
send "root\r"
expect {Password*}
send "password\r"
expect {Type your choice \[unix\]:}
send "\r"
expect {Location of UNIX socket \[\]}
send "/var/run/mysqld/mysqld.sock\r"
expect {Database name to use* \[\]}
send "horde\r"
expect {Internally used charset* \[utf-8\]}
send "\r"
expect {Type your choice \[0\]:}
send "\r"
expect {Certification Authority to use for SSL connections \[\]}
send "\r"
expect {Type your choice \[false\]:}
send "\r"
expect {Specify*}
send "adminuser\r"
expect {Thank*}
interact 
