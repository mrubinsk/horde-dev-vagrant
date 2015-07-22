#!/usr/bin/env bash
# Create swap, since image only has 512 MB
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

# Add PHP5 repository
export LANG=C.UTF-8
#add-apt-repository -y ppa:ondrej/php5

# Upgrade Ubuntu
apt-get update
apt-get upgrade -y

echo 'Installing expect.'
apt-get -y install expect

# Add PHP5/Apache from repo
apt-get -y install apache2
apt-get -y install php5 php5-dev php-pear php5-mysql phpunit

# enable mod_rewrite
a2enmod rewrite

/etc/init.d/apache2 restart

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
