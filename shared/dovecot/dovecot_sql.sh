#!/usr/bin/env bash

echo 'Provisioning Environment with Dovecot';
if which dovecot > /dev/null; then
    echo 'Dovecot is already installed'
else
    echo 'Installing Dovecot'
    debconf-set-selections <<< "dovecot-core dovecot-core/create-ssl-cert boolean true"
    debconf-set-selections <<< "dovecot-core dovecot-core/ssl-cert-name string $HOSTNAME"
    sudo apt-get -qq -y install dovecot-core dovecot-imapd dovecot-mysql dovecot-sieve dovecot-managesieved

    sed -i '/^driver =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
    echo -e 'driver = mysql' | sudo tee -a /etc/dovecot/dovecot-sql.conf.ext

    sed -i '/^connect =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
    echo -e 'connect = host=127.0.0.1 dbname=mail user=mail password=mailpassword' | sudo tee -a /etc/dovecot/dovecot-sql.conf.ext

    sed -i '/^default_pass_scheme =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
    echo -e 'default_pass_scheme = SHA512-CRYPT' | sudo tee -a /etc/dovecot/dovecot-sql.conf.ext

    sed -i '/^password_query =.*/s/^/#/g' /etc/dovecot/dovecot-sql.conf.ext
    echo -e "password_query = SELECT email as user, password FROM mailbox WHERE email='%u';" | sudo tee -a /etc/dovecot/dovecot-sql.conf.ext
    echo -e "user_query = SELECT '/var/vmail/%d/%n' as home, 'maildir:/var/vmail/%d/%n' as mail, 150 AS uid, 8 AS gid FROM mailbox WHERE email = '%u'" | sudo tee -a /etc/dovecot/dovecot-sql.conf.ext
    echo -e "iterate_query = SELECT email AS user FROM mailbox;"

    echo -e 'disable_plaintext_auth = yes' | sudo tee -a /etc/dovecot/conf.d/10-auth.conf
    sed -i '/^auth_mechanisms =.*/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
    echo -e 'auth_mechanisms = plain login' | sudo tee -a /etc/dovecot/conf.d/10-auth.conf

    sed -i '/\!include auth-system\.conf\.ext/s/^/#/g' /etc/dovecot/conf.d/10-auth.conf
    sed -i '/\!include auth-sql\.conf\.ext/s/^#//g' /etc/dovecot/conf.d/10-auth.conf

    sed -i '/^mail_location =.*/s/^/#/g' /etc/dovecot/conf.d/10-mail.conf
    echo -e 'mail_location = maildir:/var/vmail/%d/%n' | sudo tee -a /etc/dovecot/conf.d/10-mail.conf
    echo -e 'mail_uid = vmail' | sudo tee -a /etc/dovecot/conf.d/10-mail.conf
    echo -e 'mail_gid = mail' | sudo tee -a /etc/dovecot/conf.d/10-mail.conf
    echo -e 'first_valid_uid = 150' | sudo tee -a /etc/dovecot/conf.d/10-mail.conf
    echo -e 'last_valid_uid = 150' | sudo tee -a /etc/dovecot/conf.d/10-mail.conf

    if [[ ! -f /etc/dovecot/conf.d/10-master.conf.orig ]]; then
        mv /etc/dovecot/conf.d/10-master.conf /etc/dovecot/conf.d/10-master.conf.orig
    fi

    master="service imap-login {\n
      inet_listener imap {\n
        # port = 143\n
      }\n
      inet_listener imaps {\n
        #port = 993\n
        #ssl = yes\n
      }\n
    }\n
    service lmtp {\n
      unix_listener /var/spool/postfix/private/dovecot-lmtp {\n
      mode = 0600\n
      user = postfix\n
      group = postfix\n
      }\n
    }\n
    service imap {\n
    }\n
    service pop3 {\n
    }\n
    service auth {\n
      unix_listener /var/spool/postfix/private/auth {\n
        mode = 0666\n
        user = postfix\n
        group = postfix\n
      }\n
      unix_listener auth-userdb {\n
       mode = 0666\n
       user = vmail\n
       group = mail\n
      }\n
      # Auth process is run as this user.\n
      user = dovecot\n
    }\n
    service auth-worker {\n
      user = vmail\n
    }\n
    service dict {\n
      unix_listener dict {\n
      }\n
    }"
    echo -e $master | sudo tee -a /etc/dovecot/conf.d/10-master.conf

    sieve="protocol lmtp {\n
  postmaster_address = admin@example.com\n
  mail_plugins = $mail_plugins sieve\n
}"
  echo -e $sieve | sudo tee -a /etc/dovecot/conf.d/20-lmtp.conf

  chown -R vmail:dovecot /etc/dovecot
  chmod -R o-rwx /etc/dovecot

  service dovecot restart
fi