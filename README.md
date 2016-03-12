horde-dev-vagrant
=================

Vagrant images for Horde. Requires Vagrant 1.8. These should be considered for
DEVELOPMENT use only, or as a starting point for a more complete Vagrant image.
Some of the images are still a work in progress, but the pear images are mostly
done and fully functional.

Usage:
  - change to the desired setup/* directory
  - Run "vagrant up". That's it.
    - To destroy, run "vagrant destroy"

Notes:

    - Installs either MySQL or MariaDB,
      Dovecot or Cyrus, and Postfix (configured for local delivery only).
      Email can be sent between any local users using e.g., testuser@localhost

    - Images using various versions of PHP - 5.4, 5.5, 7.0. This is selected
      by choosing the shared/phpxx.sh file desired in the Vagrantfile.

    - By default, Horde is installed to /var/www/html/horde - this can be
      changed by editing shared/conf.sh file.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
       - guest/guest
       - adminuser/adminpassword

    - Horde is reachable on port 8080 of the host running the virtual image.
      This can be changed by changing the network config in the Vagrantfile
      of the image. If you change the git-master-image you also need to change
      the provided horde-conf.php file as well.

    - For the git images, any change to base configurations may require
      corresponding changes to various horde config files. E.g., changing the
      administive user/password will require corresponding change in imp's
      backend file for cyrus etc...

Following are the available images. The pear images are complete and more fully
tested. The php7 image and some of the cyrus images may still need some tweaks.

git-master-dev:         Current git master.

git-master-cyrus:       Current git master using cyrus-imapd with kolab
                        annotations available instead of stock dovecot.

git-master-php7:        Current git master running on PHP7.

pear-horde-5.2:         Installs the current Horde Groupware Webmail Edition
                        running on PHP 5.5.

pear-horde-mariadb-5.2: Same as pear-horde-5.2, but running MariaDB instead of
                        mySql.

pear-horde-php54-5.2:   Same as pear-horde-5.2, but running on PHP 5.4.