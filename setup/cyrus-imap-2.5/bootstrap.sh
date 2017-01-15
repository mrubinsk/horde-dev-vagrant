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

echo 'Installing expect.'
apt-get -y install expect


