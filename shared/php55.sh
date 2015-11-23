#!/usr/bin/env bash

echo "Provisioning for PHP 5.5.x"

# PHP 5.5
add-apt-repository -y ppa:ondrej/php5
apt-get update

apt-get -y install php5 php5-dev php-pear php5-mysql php5-gd php5-imagick phpunit

# enable mod_rewrite
a2enmod rewrite

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini