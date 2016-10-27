#!/usr/bin/env bash
apt-get install -y amavisd-new spamassassin clamav-daemon pyzor razor arj \
    cabextract lzop nomarch ripole rpm2cpio tnef unzip unrar-free \
    zip zoo

# Update clamav definitions
freshclam
/etc/init.d/amavis restart

# Add users to each other's group.
adduser clamav amavis
adduser amavis clamav

# Enable spam and virus checking.
sed -i '/^\s*#\s*@bypass_virus_checks_maps/s/#/ /g' /etc/amavis/conf.d/15-content_filter_mode
sed -i '/^\s*#\s*\\%bypass_virus_checks/s/#/ /g' /etc/amavis/conf.d/15-content_filter_mode

sed -i '/^\s*#\s*@bypass_spam_checks_maps/s/#/ /g' /etc/amavis/conf.d/15-content_filter_mode
sed -i '/^\s*#\s*\\%bypass_spam_checks/s/#/ /g' /etc/amavis/conf.d/15-content_filter_mode

# Enable amavis in postfix and restart.
postconf -e "content_filter = smtp-amavis:[127.0.0.1]:10024"
/etc/init.d/postfix restart

#enable razor
su - amavis -s /bin/bash
razor-admin -create
razor-admin -register
pyzor discover
exit
/etc/init.d/clamav-daemon restart

