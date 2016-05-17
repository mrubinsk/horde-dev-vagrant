#!/usr/bin/env bash

echo "Provisioning for PHP 5.6.x"

# PHP 5.6
add-apt-repository -y ppa:ondrej/php5-5.6
apt-get update

apt-get -y install php5 php5-dev php-pear php5-mysql php5-intl php5-tidy php5-mcrypt php5-gd php5-imagick

echo "Upgrading PEAR"
pear channel-update pear
pear upgrade -c pear

pear install Math_BigInteger
pecl install jsonc

# enable mod_rewrite
a2enmod rewrite

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf
sudo mv /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/default-ssl.conf.bak > /etc/apache2/sites-available/default-ssl.conf

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini

# Needs testing
# echo 'Installing PECL extensions'
# pecl install pecl/msgpack-0.5.7
# echo "extension=msgpack.so" >> /etc/php5/mods-available/msgpack.ini
# php5enmod msgpack
# pecl install pecl/raphf-1.1.2
# pecl install pecl/propro-1.0.2
# echo "extension=raphf.so
# extension=propro.so" > /etc/php5/mods-available/http.ini
# php5enmod http
# pecl install pecl_http-2.5.6
# echo "extension=http.so" >> /etc/php5/mods-available/http.ini