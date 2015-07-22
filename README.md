horde-dev-vagrant
=================

Vagrant images for Horde. These should be considered for
DEVELOPMENT use only, or as a starting point for a more
complete Vagrant image.

Usage:
  - change to the desired setup/* directory
  - Run "vagrant up". That's it.
    - To destroy, run "vagrant destroy"

Common to all images:

    - Installs MySQL, Dovecot, and Postfix configured for local delivery only.
     Email can be sent between any local users using e.g., testuser@localhost
    - By default, Horde is installed to /var/www/html/horde - this can be
      changed by editing shared/conf.sh file.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
       - guest/guest
       - adminuser/adminpassword

Available images:

git-master-dev: Current git master.

pear-horde-5.2: Installs the current Horde Groupware Webmail Edition.
