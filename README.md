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

    - Horde is reachable on port 8080 of the host running the virtual image.
      This can be changed by changing the network config in the Vagrant file
      of the image. If you change the git-master-image you also need to change
      the provided horde-conf.php file as well.

    - For the git images, any change to base configurations may require
      corresponding changes to various horde config files. E.g., changing the
      administive user/password will require corresponding change in imp's
      backend file for cyrus etc...

Available images:

git-master-dev: Current git master.

git-master-cyrus: Current git master using cyrus-imapd with kolab annotations
                  available instead of stock dovecot.

pear-horde-5.2: Installs the current Horde Groupware Webmail Edition.
