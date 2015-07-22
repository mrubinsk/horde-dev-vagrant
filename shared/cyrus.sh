#!/usr/bin/env bash

echo 'Provisioning Environment with Cyrus';
if which cyrus > /dev/null; then
    echo 'Cyrus is already installed'
else
    echo 'Installing Cyrus'
    debconf-set-selections <<< "cyrus-common cyrus-common/removespools boolean true"
    sudo apt-get -qq -y install cyrus-imapd cyrus-admin sasl2-bin

    echo "Adding vagrant user and $ADMINUSER to Cyrus admins in imapd.conf"
    echo -e "admins: vagrant $ADMINUSER" | sudo tee -a /etc/imapd.conf

    echo "Adding custom annotations to Cyrus in imapd.conf"
    echo -e "annotation_definitions: /etc/annotations.conf" | sudo tee -a /etc/imapd.conf
    echo -e "/vendor/kolab/folder-type,mailbox,string,backend,value,a\n/vendor/horde/share-params,mailbox,string,backend,value,a" | sudo tee -a /etc/annotations.conf

    echo 'Setting saslauthd to run at startup.'
    echo -e 'START=yes' | sudo tee -a /etc/default/saslauthd

    # Needed so vagrant can run cyradm
    echo 'Adding the vagrant user to sasldb.'
    echo "vagrant" | sudo saslpasswd2 -p -c vagrant
fi

echo 'Starting the imapd and saslauthd services.'
sudo /etc/init.d/saslauthd start
sudo /etc/init.d/cyrus-imapd start

echo 'Creating demo user accounts.'
echo "$TESTUSERONEPASS" | sudo saslpasswd2 -p -c $TESTUSERONE
echo "$TESTUSERTWOPASS" | sudo saslpasswd2 -p -c $TESTUSERTWO
echo "$ADMINUSERPASS"   | sudo saslpasswd2 -p -c $ADMINUSER

# Setup Cyrus to deliver to postfix properly.
echo -e 'lmtp      unix  -       -       n       -       -       lmtp' | sudo tee -a /etc/postfix/master.cf

sudo addgroup lmtp
sudo adduser postfix lmtp
sudo dpkg-statoverride --force --update --add cyrus lmtp 750 /var/run/cyrus/socket

echo -e 'mailbox_transport=lmtp:unix:/var/run/cyrus/socket/lmtp' | sudo tee -a /etc/postfix/main.cf

sudo /etc/init.d/postfix restart
sudo /etc/init.d/cyrus-imapd restart