#!/usr/bin/env bash

echo "Provisioning for PHP 5.5.x"

# PHP 5.5
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
apt-get update

apt-get -y install php5.5 php5.5-dev php-pear php5.5-mysql php5.5-intl php5.5-tidy php5.5-mcrypt php5.5-gd php5.5-imagick php5.5-mbstring php5.5-xml php5.5-curl
update-alternatives --set php /usr/bin/php5.5

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

# Needs testing.
# echo 'Installing PECL extensions'
# pecl install pecl/msgpack-0.5.7
# echo "extension=msgpack.so" >> /etc/php5/mods-available/msgpack.ini
# php5enmod msgpack
# pecl install pecl/raphf-1.1.2
# pecl install pecl/propro-1.0.2
# echo "extension=raphf.so
# extension=propro.so" > /etc/php5/mods-available/http.ini
# php5enmod http
# pecl install pecl_http-2.5.5
# echo "extension=http.so" >> /etc/php5/mods-available/http.ini