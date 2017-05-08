#!/usr/bin/env bash

echo 'Creating horde database.'
mysql -u root --password=$MYSQLPASSWORD -e "create database horde";

# Install Horde from source
apt-get install -y git

mkdir -p /horde/src

# Get the git-tools-package
git clone https://github.com/mrubinsk/horde-git-tools.git /horde/tools
chown -R vagrant:vagrant /horde/tools
chown -R vagrant:vagrant /horde/src

# For now, we require a legacy git repo checkout in ~/horde-git
# Must do this as the vagrant user so the horde-git source is linked correctly.
su - vagrant -c "git clone --depth 1 https://github.com/horde/horde.git /home/vagrant/horde-git ; cd /horde/tools; composer --ignore-platform-reqs install"

# Copy the config file.
cp /vagrant/conf/git-tools-conf.php /horde/tools/config/conf.php

# Clone the repo
su - vagrant -c "/horde/tools/bin/horde-git-tools git clone"

# # Move prebuilt configuration over.
echo 'Copying configuration files.'
cp /vagrant/conf/horde/* /horde/src/applications/base/config/
cp /vagrant/conf/imp/* /horde/src/applications/imp/config/
cp /vagrant/conf/kronolith/* /horde/src/applications/kronolith/config/
cp /vagrant/conf/turba/* /horde/src/applications/turba/config/
cp /vagrant/conf/ingo/* /horde/src/applications/ingo/config/
chown www-data:www-data /horde/src/applications/base/config/conf.php

#Install Horde_Role
echo "Configuring PEAR"
pear channel-discover pear.horde.org
pear install --force --nodeps /horde/src/Role/package.xml
pear config-set horde_dir $HORDEDIR

# Link
/horde/tools/bin/horde-git-tools dev install

echo 'Restarting Apache.'
/etc/init.d/apache2 restart

# For now, we pass the base-directory since we haven't moved away from the
# monolithic repo yet.
/horde/src/applications/base/bin/horde-db-migrate --base-directory=/horde/src
/horde/src/applications/base/bin/horde-db-migrate --base-directory=/horde/src
