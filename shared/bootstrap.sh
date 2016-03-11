#!/usr/bin/env bash
# Create swap, since image only has 512 MB
echo 'Creating swap file.'
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

echo "Adding vagrant user to users group"
usermod -a -G users vagrant

export LANG=C.UTF-8

# Upgrade Ubuntu
echo 'Upgrading Ubuntu'
apt-get update
apt-get upgrade -y

echo 'Ensuring desired locales are available.'
# Uncomment to enable all supported locales.
# ln -s /usr/share/i18n/SUPPORTED /var/lib/locales/supported.d/all
# locale-gen
locale-gen de_DE
locale-gen de_DE.UTF-8

echo 'Installing expect.'
apt-get -y install expect

echo "Installing Apache"
apt-get -y install apache2 libcurl4-openssl-dev libpcre3-dev

echo "Insatlling Aspell"
apt-get -y install aspell

