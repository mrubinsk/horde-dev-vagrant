#!/usr/bin/env bash

apt-get install -y git

#mkdir -p /var/www/pear.horde.org
cp /vagrant/pirum.xml /var/www/pirum.xml
mkdir -p /horde/src

echo "Building PIRUM channel"
git clone https://github.com/horde/Pirum.git /horde/src/Pirum; cd /horde/src/Pirum; git checkout production
cp /horde/src/Pirum/pirum /usr/local/bin/pirum
php /usr/local/bin/pirum build /var/www/
chown -R demo:users /var/www
usermod -G users demo

# Cleanup
sudo apt-get -y autoremove
