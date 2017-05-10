#!/usr/bin/env bash
echo "Installing Apache"
apt-get -y install apache2 libcurl4-openssl-dev libpcre3-dev

echo "Adding Alias rule for ActiveSync"
sudo mv /etc/apache2/sites-available/default /etc/apache2/sites-available/default.bak
sudo awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/horde/rpc.php"; next}1' /etc/apache2/sites-available/default.bak > /etc/apache2/sites-available/default

echo "Adding Redirect for WebDav"
sudo mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
sudo awk '/<VirtualHost/ { print; print "RedirectPermanent /.well-known/caldav /horde/rpc.php/"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
a2enmod rewrite
