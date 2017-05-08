#!/usr/bin/env bash

echo "Installing Git and Composer."
sudo apt-get install -y curl
curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
