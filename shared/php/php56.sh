#!/usr/bin/env bash

echo "Provisioning for PHP 5.6.x"

# PHP 5.6
LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
apt-get update

apt-get -y install php5.6 php5.6-dev php-pear php5.6-mysql php5.6-intl php5.6-tidy php5.6-mcrypt php5.6-gd php5.6-imagick php5.6-mbstring php5.6-xml php5.6-curl
update-alternatives --set php /usr/bin/php5.6

echo "Upgrading PEAR"
pear channel-update pear
pear upgrade -c pear

pear install Math_BigInteger
pecl install jsonc
