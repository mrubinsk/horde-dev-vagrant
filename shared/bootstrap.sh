#!/usr/bin/env bash
# Create swap, since image only has 512 MB
fallocate -l 512M /swapfile
chmod 600 /swapfile
mkswap /swapfile
swapon /swapfile
echo '/swapfile none swap defaults 0 0' >> /etc/fstab

# Add PHP5 repository
export LANG=C.UTF-8
#add-apt-repository -y ppa:ondrej/php5

# Upgrade Ubuntu
apt-get update
apt-get upgrade -y

echo 'Installing expect.'
apt-get -y install expect

# Generate a test user.
if getent passwd $TESTUSERONE > /dev/null; then
    echo "$TESTUSERONE already exists"
else
    echo "Creating User '$TESTUSERONE' with password '$TESTUSERONEPASS'"
    sudo useradd $TESTUSERONE -m -s /bin/bash
    echo "$TESTUSERONE:$TESTUSERONEPASS"|sudo chpasswd
    echo 'User created'
fi

# Generate a test user.
if getent passwd $TESTUSERTWO > /dev/null; then
    echo "$TESTUSERTWO already exists"
else
    echo "Creating User '$TESTUSERTWO' with password '$TESTUSERTWOPASS'"
    sudo useradd $TESTUSERTWO -m -s /bin/bash
    echo "$TESTUSERTWO:$TESTUSERTWOPASS"|sudo chpasswd
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

# Add PHP5/Apache from repo
apt-get -y install apache2
apt-get -y install php5 php5-dev php-pear php5-mysql phpunit

# enable mod_rewrite
sudo a2enmod rewrite

# Add php-ini location
pear config-set php_ini /etc/php5/apache2/php.ini
