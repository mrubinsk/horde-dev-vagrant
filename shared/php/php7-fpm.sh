#!/usr/bin/env bash

echo "Provisioning for PHP 7.0"

# PHP 5.6
add-apt-repository ppa:ondrej/php
apt-get update

apt-get -y install php-fpm php-dev php-mysql php-gd php-imagick php-mbstring php-zip
