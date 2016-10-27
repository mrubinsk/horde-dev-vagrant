#!/usr/bin/env bash

# Setting up DKIM and SPF support.

apt-get install opendkim opendkim-tools postfix-policyd-spf-python

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
echo "YOU MUST EDIT THESE FILES WITH YOUR DOMAIN NAMES"
echo -e '*.@example.com example.com' | sudo tee -a /etc/opendkim/signing.table
echo -e 'example     example.com:YYYYMM:/etc/opendkim/keys/example.private' | sudo tee -a /etc/opendkim/key.table
trusted="127.0.0.1\n::1\nlocalhost\nmyhostname\nmyhostname.example.com\nexample.com"
echo -e $trusted | sudo tee -a /etc/opendkim/trusted.hosts

chown -R opendkim:opendkim /etc/opendkim
chmod -R go-rwx /etc/opendkim/keys

opendkim-genkey -b 2048 -r -s YYYYMM
mv YYYYMM.private example.private
mv YYYYMM.txt example.txt

chown -R opendkim:opendkim /etc/opendkim
chmod -R go-rw /etc/opendkim/keys

echo -e 'SOCKET="local:/var/spool/postfix/opendkim/opendkim.sock"' | sudo tee -a /etc/default/opendkim

postconf -e 'milter_default_action = accept'
postconf -e 'milter_protocol = 6'
postconf -e 'smtpd_milters = local:/opendkim/opendkim.sock'
postconf -e 'non_smtpd_milters = local:/opendkim/opendkim.sock'