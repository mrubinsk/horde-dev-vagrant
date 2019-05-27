#!/usr/bin/env bash

echo "Provisioning for PHP-FPM 7.3"

# Used for socket location if needed.
echo "export PHPVERSIONSTRING=php7.3-fpm" >> ~/.profile

apt-get install software-properties-common
add-apt-repository ppa:ondrej/php
apt-get update
apt-get -y install php7.3-fpm php7.3-dev php7.3-mysql php7.3-gd php7.3-imagick php7.3-mbstring php7.3-xml php7.3-dom
