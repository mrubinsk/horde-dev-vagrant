#!/usr/bin/env bash

echo 'Installing horde-git-tools.'

apt-get install git zip -y
git clone https://github.com/horde/git-tools.git "$HORDETOOLS"
chown "$VAGRANTUSER":"$VAGRANTUSER" -R "$HORDETOOLS"

pushd "$HORDETOOLS"
sudo -H -u "$VAGRANTUSER" composer install
popd

ln -s "$HORDETOOLS"/bin/horde-git-tools /usr/local/bin/horde-git-tools
cp "$HORDETOOLS"/config/conf.php.dist "$HORDETOOLS"/config/conf.php

sed -i "s|\$conf\['git_base'\] = '';|\$conf\['git_base'\] = '"$HORDESRC"';|" "$HORDETOOLS"/config/conf.php
sed -i "s|\$conf\['web_base'\] = '';|\$conf\['web_base'\] = '"$HORDEDIR"';|" "$HORDETOOLS"/config/conf.php
sed -i "s|\$conf\['static_group'\] = '';|\$conf\['static_group'\] = 'www-data';|" "$HORDETOOLS"/config/conf.php

if [[ "$GIT_DEPTH" == "shallow" ]]; then
    sed -i "s|^\$conf\['clone'\].*|\$conf\['clone'\] = '--depth 1';|" "$HORDETOOLS"/config/conf.php
else
    sed -i "s|^\$conf\['clone'\].*|\$conf\['clone'\] = '';|" "$HORDETOOLS"/config/conf.php
fi
