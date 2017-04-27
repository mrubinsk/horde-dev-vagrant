#!/usr/bin/env bash

echo "Provisioning for PHP 5.4.x"

# PHP 5.4.x
add-apt-repository -y ppa:ondrej/php5-oldstable
apt-get update

apt-get -y install php5 php5-dev php-pear php5-mysql php5-intl php5-tidy php5-mcrypt php5-gd php5-imagick php5-mbstring phpunit

echo "Upgrading PEAR"
pear channel-update pear
pear upgrade -c pear

pear install Math_BigInteger

# enable mod_rewrite
a2enmod rewrite

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/horde/rpc.php"; next}1' /etc/apache2/sites-available/default.bak > /etc/apache2/sites-available/default

echo "Adding Redirect for WebDav"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "RedirectPermanent /.well-known/caldav /horde/rpc.php/"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf


# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
