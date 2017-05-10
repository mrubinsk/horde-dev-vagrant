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

# TODO: Where to set this?
# Add php-ini location
#pear config-set php_ini /etc/php5/apache2/php.ini
