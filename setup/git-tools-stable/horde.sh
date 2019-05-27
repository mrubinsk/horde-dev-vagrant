#!/usr/bin/env bash

echo 'Creating horde databases.'
mysql -u root --password=$MYSQLPASSWORD -e "CREATE DATABASE IF NOT EXISTS horde";

# Create folders.
mkdir -p "$HORDESRC"
chown -R "$VAGRANTUSER":"$VAGRANTUSER" "$HORDESRC"

mkdir -p "$HORDEDIR"

mkdir -p "$VFSDIR"
chown -R www-data:www-data "$VFSDIR"

# Clone Git master
echo "Cloning horde apps and switching to $BRANCHNAME with horde-git-tools"
su - "$VAGRANTUSER" -c "horde-git-tools git clone"
su - "$VAGRANTUSER" -c "horde-git-tools git checkout $BRANCHNAME"

# Move prebuilt configuration over.
echo 'Copying configuration files.'
for APP in base imp ingo kronolith turba; do
    cp /vagrant/conf/"$APP"/* "$HORDESRC"/"$APP"/config/
done

# Set permissions.
for FOLDER in "$HORDESRC"/*; do
    if [[ -d "$FOLDER"/config ]]; then
        echo ">>> Changing owner of $FOLDER"
        chown -R www-data:"$VAGRANTUSER" "$FOLDER"/config
    fi
done

#Install Horde_Role
echo "Configuring horde_role"
pear channel-discover pear.horde.org
pear install --force --nodeps "$HORDESRC"/Role/package.xml
pear config-set horde_dir "$HORDEDIR"

# Install framework
horde-git-tools dev install

chown -R www-data:www-data "$HORDEDIR"

$HORDESRC/base/bin/horde-db-migrate
$HORDESRC/base/bin/horde-db-migrate
