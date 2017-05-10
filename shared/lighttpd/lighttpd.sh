#!/usr/bin/env bash
apt-get -y install lighttpd

cp /etc/lighttpd/conf-available/15-fastcgi.php /etc/lighttpd/conf-available/15-fastcgi.php.bu
echo -e 'fastcgi.server += ( ".php" =>
        ((
                "socket" => "/var/run/php/php7.0-fpm.sock",
                "broken-scriptfilename" => "enable"
        ))
)' | sudo tee -a /etc/lighttpd/conf-available/15-fastcgi.php
