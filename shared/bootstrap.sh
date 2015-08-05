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

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/html/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf
 echo -e 'mail_location = mbox:~/mail' | sudo tee -a /etc/dovecot/local.conf
/etc/init.d/apache2 restart

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
