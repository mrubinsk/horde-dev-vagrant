#!/usr/bin/env bash

echo 'Provisioning Environment with Procmail and Postfix LDA.';
if which procmail > /dev/null; then
    echo 'Procmail is already installed.'
else
    sudo apt-get install -y procmail
    echo -e 'mailbox_command = /usr/bin/procmail -a "$EXTENSION" DEFAULT=$HOME/mail/inbox' | sudo tee -a /etc/postfix/main.cf
    service postfix reload
fi