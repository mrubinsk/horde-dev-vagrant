#!/usr/bin/env bash

# TODO, make this configurable.
echo 'Provisioning Environment with Postfix for LOCAL delivery ONLY.';
if which postfix > /dev/null; then
    echo 'Postfix is already installed.'
else
    debconf-set-selections <<< "postfix postfix/mailname string $HOSTNAME"
    debconf-set-selections <<< "postfix postfix/main_mailer_type string Local only"
    sudo apt-get install -y postfix
    postconf -e 'home_mailbox = mail/inbox'
    postconf -e "myhostname = $HOSTNAME"
    postconf -e "mydomain = $HOSTNAME"
    postconf -e "myorigin = /$mydomain"
    postconf -e "mydestination = $HOSTNAME"
    service postfix reload
fi