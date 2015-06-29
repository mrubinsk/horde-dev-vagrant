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

# mysql password
PASSWORD='password'
HORDEDIR='/var/www/html/horde'

# mysql
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
apt-get -y install mysql-server-5.5

mysql -u root --password=$PASSWORD -e "create database horde";

echo 'Provisioning Environment with Dovecot';
if which dovecot > /dev/null; then
    echo 'Dovecot is already installed'
else
    echo 'Installing Dovecot'
    sudo apt-get -qq -y install dovecot-imapd 
    sudo touch /etc/dovecot/local.conf
    sudo echo 'mail_location = maildir:/home/%u/Maildir' >> /etc/dovecot/local.conf
    sudo echo 'disable_plaintext_auth = no' >> /etc/dovecot/local.conf
    sudo restart dovecot
fi

# Generate a test user.
if getent passwd testuser > /dev/null; then
    echo 'testuser already exists'
else
    echo 'Creating User "testuser" with password "password"'
    sudo useradd testuser -m -s /bin/bash
    echo "testuser:password"|sudo chpasswd
    echo 'User created'
 fi

# Add PHP5/Apache from repo
apt-get -y install apache2
apt-get -y install php5 php5-dev php-pear php5-mysql phpunit
# setup hosts file
#VHOST=$(cat <<EOF
#<VirtualHost *:80>
#    DocumentRoot "/var/www/html/${HORDEDIR}"
#    <Directory "/var/www/html/${HORDEDIR}">
#        AllowOverride All
#        Require all granted
#    </Directory>
#</VirtualHost>
#EOF
#)
#echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
