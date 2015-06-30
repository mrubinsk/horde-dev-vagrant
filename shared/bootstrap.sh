#!/usr/bin/env bash

# Create swap, since image only has 512 MB
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

# Add PHP5 repository
export LANG=C.UTF-8
add-apt-repository -y ppa:ondrej/php5

# Upgrade Ubuntu 
apt-get update
apt-get upgrade -y

# mysql password
PASSWORD='password'

#test user and pass.
TESTUSER=testuser
TESTUSERPASS=password

ADMINUSER=adminuser
ADMINUSERPASS=adminpassword

echo 'Provisioning MySQL server.'
debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORD"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORD"
apt-get -y install mysql-server-5.5

echo 'Creating horde database.'
mysql -u root --password=$PASSWORD -e "create database horde";

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

echo 'Installing expect.'
apt-get -y install expect

# Generate a test user.
if getent passwd $TESTUSER > /dev/null; then
    echo "$TESTUSER already exists"
else
    echo "Creating User '$TESTUSER' with password '$TESTUSERPASS'"
    sudo useradd $TESTUSER -m -s /bin/bash
    echo "$TESTUSER:$TESTUSERPASS"|sudo chpasswd
    echo 'User created'
fi

# Generate the admin user.
if getent passwd $ADMINUSER > /dev/null; then
    echo "$ADMINUSER already exists"
else
    echo "Creating User '$ADMINUSER' with password '$ADMINUSERPASS'"
    sudo useradd $ADMINUSER -m -s /bin/bash
    echo "$ADMINUSER:$ADMINUSERPASS"|sudo chpasswd
    echo 'User created'
fi

sudo stop dovecot
[ -d "/home/$TESTUSER/mail" ] && sudo rm -R /home/$TESTUSER/mail
sudo cp -Rp /vagrant/empty.mbox /home/$TESTUSER/mail/inbox.mbox
sudo chown -R $TESTUSER:$TESTUSER /home/$TESTUSER/mail
sudo start dovecot
 
echo 'Test mailbox restored'.

# Add PHP5/Apache from repo
apt-get -y install apache2
apt-get -y install php5 php5-dev php-pear php5-mysql phpunit

# enable mod_rewrite
sudo a2enmod rewrite

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
