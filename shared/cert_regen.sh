#!/usr/bin/env bash
#
echo 'Regenerating default ssl-cert for real hostname. YOU SHOULD REPLACE THIS WITH A REAL CERT!'
apt-get install --assume-yes ssl-cert
make-ssl-cert generate-default-snakeoil --force-overwrite