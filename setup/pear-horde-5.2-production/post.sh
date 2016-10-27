#!/usr/bin/env bash
/etc/init.d/amavis restart
/etc/init.d/clamav-daemon restart
/etc/init.d/postfix restart
service dovecot restart
/etc/init.d/apache2 restart