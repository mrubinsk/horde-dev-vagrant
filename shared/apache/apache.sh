#!/usr/bin/env bash
echo "Installing Apache"
apt-get -y install apache2 libcurl4-openssl-dev libpcre3-dev

echo "Adding Alias rule for ActiveSync"
mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
awk '/<VirtualHost/ { print; print "Alias /Microsoft-Server-ActiveSync /var/www/horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

echo "Adding Redirect for WebDav"
mv /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak
awk '/<VirtualHost/ { print; print "RedirectPermanent /.well-known/caldav /horde/rpc.php"; next}1' /etc/apache2/sites-available/000-default.conf.bak > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
a2enmod rewrite

# Avoid "could not reliably determine server's fully qualified domain name"
echo "ServerName localhost" > /etc/apache2/conf-available/fqdn.conf
a2enconf fqdn

service apache2 reload
