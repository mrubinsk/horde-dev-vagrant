#!/usr/bin/env bash

# Setting up DKIM and SPF support.

apt-get install -y opendkim opendkim-tools postfix-policyd-spf-python

adduser postfix opendkim

postconf -M policyd-spf/unix="policyd-spf   unix    -   n   n   -   0   spawn user=policyd-spf argv=/usr/bin/policyd-spf"
postconf -e 'policyd-spf_time_limit = 3600'

echo 'Setting up DKIM'
echo -e 'UserID          opendkim' | sudo tee -a /etc/opendkim.conf
echo -e 'KeyTable        /etc/opendkim/key.table' | sudo tee -a /etc/opendkim.conf
echo -e 'SigningTable        refile:/etc/opendkim/signing.table' | sudo tee -a /etc/opendkim.conf
echo -e 'ExternalIgnoreList  /etc/opendkim/trusted.hosts' | sudo tee -a /etc/opendkim.conf
echo -e 'InternalHosts       /etc/opendkim/trusted.hosts' | sudo tee -a /etc/opendkim.conf
echo -e 'Canonicalization    relaxed/simple' | sudo tee -a /etc/opendkim.conf
echo -e 'Mode            sv' | sudo tee -a /etc/opendkim.conf
echo -e 'SubDomains      no' | sudo tee -a /etc/opendkim.conf
echo -e 'AutoRestart     yes' | sudo tee -a /etc/opendkim.conf
echo -e 'AutoRestartRate     10/1M' | sudo tee -a /etc/opendkim.conf
echo -e 'Background      yes' | sudo tee -a /etc/opendkim.conf
echo -e 'DNSTimeout      5' | sudo tee -a /etc/opendkim.conf
echo -e 'SignatureAlgorithm  rsa-sha256' | sudo tee -a /etc/opendkim.conf

# Just in case
chmod u=rw,go=r /etc/opendkim.conf

mkdir /etc/opendkim
mkdir /etc/opendkim/keys
chown -R opendkim:opendkim /etc/opendkim
chmod go-rw /etc/opendkim/keys

echo "Creating the directories and configuration files for DKIM."
echo -e "*.@$DOMAIN mydomain" | sudo tee -a /etc/opendkim/signing.table
echo -e 'mydomain $DOMAIN:dkey:/etc/opendkim/keys/mydomain.private' | sudo tee -a /etc/opendkim/key.table
trusted="127.0.0.1\n::1\nlocalhost\n$HOSTNAME\n$DOMAIN"
echo -e $trusted | sudo tee -a /etc/opendkim/trusted.hosts

chown -R opendkim:opendkim /etc/opendkim
chmod -R go-rwx /etc/opendkim/keys

opendkim-genkey -b 2048 -r -s dkey
mv dkey.private /etc/opendkim/keys/mydomain.private
mv dkey.txt /etc/opendkim/keys/example.txt

chown -R opendkim:opendkim /etc/opendkim
chmod -R go-rw /etc/opendkim/keys

echo -e 'SOCKET="inet:8891@localhost"' | sudo tee -a /etc/default/opendkim
postconf -e 'milter_default_action = accept'
postconf -e 'milter_protocol = 6'
postconf -e 'smtpd_milters = inet:localhost:8891'
postconf -e 'non_smtpd_milters = inet:localhost:8891    '
