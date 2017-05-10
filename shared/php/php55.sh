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

# Add php-ini location
# pear config-set php_ini /etc/php5/apache2/php.ini
