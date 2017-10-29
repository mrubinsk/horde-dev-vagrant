#!/usr/bin/env bash
#
# Create folders.
mkdir -p "$HORDESRC"
chown -R "$VAGRANTUSER":"$VAGRANTUSER" "$HORDESRC"

# Clone Git master
echo 'Cloning horde apps from git with horde-git-tools'
su - "$VAGRANTUSER" -c "horde-git-tools git clone"

# Move prebuilt configuration over.
echo 'Copying configuration files.'
for APP in base imp ingo kronolith turba; do
    cp /vagrant/conf/"$APP"/* "$HORDESRC"/"$APP"/config/
done

# Set permissions.
for FOLDER in "$HORDESRC"/*; do
    if [[ -d "$FOLDER"/config ]]; then
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

echo 'Restarting Apache.'
/etc/init.d/apache2 restart

/horde/src/base/bin/horde-db-migrate
/horde/src/base/bin/horde-db-migrate
