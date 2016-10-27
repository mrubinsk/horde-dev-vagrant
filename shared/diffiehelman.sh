#!/usr/bin/env bash

#echo 'Setting HOSTNAME'

echo 'Generating new diffie-helman group.'
openssl dhparam -out /etc/ssl/private/dhparams.pem 2048
chmod 600 /etc/ssl/private/dhparams.pem