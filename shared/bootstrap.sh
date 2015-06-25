#!/usr/bin/env bash

# Create swap, since image only has 512 MB
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

# Add PHP5 repository
export LANG=C.UTF-8
add-apt-repository -y ppa:ondrej/php5

# Upgrade Ubuntu 
apt-get update
apt-get upgrade -y

# Install PHP (from source)
#apt-get install -y pkg-config libxml2-dev libssl-dev libcurl-dev \
#	libcurl4-openssl-dev libjpeg-dev libpng-dev libicu-dev \
#	g++ libxdlt-dev
#cd /usr/local/src
#wget http://us2.php.net/get/php-5.5.16.tar.xz/from/this/mirror \
#	-O php-5.5.16.tar.xz
#tar -Jxf php-5.5.16.tar.xz
#cd php-5.5.16
#./configure \
#	--prefix=/usr/local/php \
#	--disable-short-tags \
#	--with-gettext \
#	--enable-fpm \
#	--enable-ftp \
#	--enable-intl \
#	--enable-mbregex \
#	--enable-mbstring=all \
#	--with-curl \
#	--with-gd \
#	--with-iconv \
#	--with-jpeg-dir \
#	--with-openssl \
#	--with-png-dir \
#	--with-xmlrpc \
#	--with-xsl \
#	--with-zlib \
#	--without-pgsql \
#	--without-mysql
#make install

# mysql
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'
apt-get install -y mysql-server

mysql -u root --password=password -e "create database horde";

# Add PHP5/Apache from repo
apt-get install -y php5 php5-dev php-pear php5-mysql phpunit

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
