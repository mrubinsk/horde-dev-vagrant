#!/usr/bin/env bash

echo "Provisioning for PHP 7-dev"
apt-get -y install libtool \
  libzip-dev \
  lbzip2 \
  libxml2-dev \
  bison \
  libbz2-dev \
  apache2-dev \
  libjpeg-dev \
  libpng-dev \
  libmcrypt-dev \
  libmysqlclient-dev \
  git \
  autoconf \
  libicu-dev

git clone --depth=1 https://github.com/php/php-src
cd php-src
./buildconf

./configure \
    --enable-mbstring \
    --enable-zip \
    --enable-ftp \
    --enable-exif \
    --enable-calendar \
    --enable-intl \
    --with-curl \
    --with-mcrypt \
    --with-iconv \
    --with-gd \
    --with-jpeg-dir=/usr \
    --with-png-dir=/usr \
    --with-zlib-dir=/usr \
    --with-openssl \
    --with-pdo-mysql=/usr \
    --with-gettext=/usr \
    --with-zlib=/usr \
    --with-bz2 \
    --with-apxs2=/usr/bin/apxs

make clean
make install

# enable mod_rewrite and PHP7
a2enmod rewrite
a2dismod mpm_worker
a2dismod mpm_event
a2enmod mpm_prefork
a2enmod php7

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini

echo "Upgrading PEAR"
pear channel-update pear
pear upgrade -c pear

pear install channel://pear.php.net/Math_BigInteger
pear install channel://pear.php.net/Net_DNS2
