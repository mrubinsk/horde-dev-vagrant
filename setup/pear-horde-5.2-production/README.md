pear-horde-5.2-production
=========================

Vagrant image for a full production-ready server. Builds a full mail and web
stack including the following:

Email
=====

- Postfix/Dovecot with SASL/TLS and SQL based virtual domains/users
- Amavisd/ClamAV/SA/Postgrey/postfix-policyd-spf
- OpenDKIM
- Dovecot
- MySQL
- Apache/PHP 5.6

Usage:
  - Review the shared/config.sh and config.sh files and edit as appropriate.
  - change to the desired setup/* directory
  - Run "vagrant up". That's it.
    - To destroy, run "vagrant destroy"

Notes:

    - Based on Ubuntu Trusty64 unless otherwise noted.

    - By default, Horde's web root is installed to /var/www/html/horde - this
      can be changed by editing shared/conf.sh file.

    - The following initial user account is created - username and passwords can
      be changed by editing the shared/conf.sh file:
