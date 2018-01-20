#!/usr/bin/env bash

echo 'Provisioning Environment with vsftpd.';
if which vsftpd > /dev/null; then
    echo 'vsftpd is already installed.'
else
    sudo apt-get install -y vsftpd
    echo -e 'write_enable=YES' | sudo tee -a /etc/vsftpd.conf
    service vsftpd restart
fi