#!/usr/bin/env bash

echo "Provisioning for PHP 7.0"

# PHP 5.6
add-apt-repository ppa:ondrej/php
apt-get update

apt-get -y install php php-dev php-mysql php-gd php-imagick php-mbstring

# enable mod_rewrite
a2enmod rewrite

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

echo "Adding Redirect for WebDav"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "RedirectPermanent /.well-known/caldav /horde/rpc.php/"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
