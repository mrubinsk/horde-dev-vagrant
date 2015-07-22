#!/usr/bin/env bash

echo 'Provisioning Environment with Dovecot';
if which dovecot > /dev/null; then
    echo 'Dovecot is already installed'
else
    echo 'Installing Dovecot'
    debconf-set-selections <<< "dovecot-core dovecot-core/create-ssl-cert boolean true"
    debconf-set-selections <<< "dovecot-core dovecot-core/ssl-cert-name string localhost"
    sudo apt-get -qq -y install dovecot-core dovecot-imapd
    sudo touch /etc/dovecot/local.conf
    echo -e 'mail_location = mbox:~/mail' | sudo tee -a /etc/dovecot/local.conf
    echo -e 'disable_plaintext_auth = no' | sudo tee -a /etc/dovecot/local.conf
    sudo restart dovecot
fi

#TODO
#sudo stop dovecot
#[ -d "/home/$TESTUSER/mail" ] && sudo rm -R /home/$TESTUSER/mail
#sudo cp -Rp /vagrant/empty.mbox /home/$TESTUSER/mail/inbox.mbox
#sudo chown -R $TESTUSER:$TESTUSER /home/$TESTUSER/mail
#sudo start dovecot

#echo 'Test mailbox restored'.