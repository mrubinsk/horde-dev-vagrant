#!/usr/bin/env bash
# Create swap, since image only has 512 MB
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

echo "Adding vagrant user to users group"
usermod -a -G users vagrant

# Add PHP5 repository
export LANG=C.UTF-8

# PHP 5.5
add-apt-repository -y ppa:ondrej/php5

# To use PHP 5.6, use:
# add-apt-repository -y ppa:ondrej/php5-5.6

# Upgrade Ubuntu
apt-get update
apt-get upgrade -y

echo 'Ensuring desired locales are available.'
locale-gen de_DE
locale-gen de_DE.UTF-8

echo 'Installing expect.'
apt-get -y install expect

# Add PHP5/Apache from repo
apt-get -y install apache2
apt-get -y install php5 php5-dev php-pear php5-mysql phpunit

# enable mod_rewrite
a2enmod rewrite

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
