#!/usr/bin/env bash

echo "Provisioning for PHP 7.3"

apt-get install python-software-properties
add-apt-repository ppa:ondrej/php
apt-get update
apt-get -y install php7.3 php7.3-dev php7.3-mysql php7.3-gd php7.3-imagick php7.3-mbstring php7.3-xml php7.3-dom
