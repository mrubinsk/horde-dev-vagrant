#!/usr/bin/env bash

# @TODO Set hostname? /etc/hostname and /etc/hosts?
hostname mail\.example\.com
echo -e mail\.example\.com | sudo tee -a /etc/hostname
sed -i 's/localhost/mail\.example\.com localhost/g' /etc/hosts

echo "export DOMAIN=example.com" >> ~/.profile
echo "export ADMINUSER=admin@example.com" >> ~/.profile
echo "export ADMINUSERPASSWORD=adminpassword" >> ~/.profile