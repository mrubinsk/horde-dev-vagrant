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

    - All images based on Ubuntu Trusty64 unless otherwise noted.

    - Installs either MySQL or MariaDB,
      Dovecot or Cyrus, and Postfix (configured for local delivery only).
      Email can be sent between any local users using e.g., testuser@localhost

    - Images using various versions of PHP - 5.4, 5.5, 7.0. This is selected
      by choosing the shared/phpxx.sh file desired in the Vagrantfile.

    - By default, Horde's web root is installed to /var/www/html/horde - this
      can be changed by editing shared/conf.sh file. For the Git images, the
      source tree is installed to /horde/src.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
       - guest/guest
       - adminuser/adminpassword

    - Horde is reachable on port 8080 of the host running the virtual image.
      This can be changed by changing the network config in the Vagrantfile
      of the image. If you change this setting you may also need to change
      Horde's config/conf.php file as well to point to the correct IP and/or
      Port.

    - For the Git images, any change to base configurations may require
      corresponding changes to various horde config files. E.g., changing the
      administive user/password will require corresponding change in imp's
      backend file for cyrus etc...

Following are the available images. The pear images are complete and more fully
tested. The php7 image and some of the cyrus images may still need some tweaks.

git-master-dev:         Current Git master.

git-master-dev-32bit:   Current Git master running on 32bit Ubuntu Trusty.

git-master-cyrus:       Current Git master using Cyrus with kolab
                        annotations available instead of stock dovecot.

git-master-php7:        Current Git master running on PHP7.

git-master-php7-dev:    Current Git master running on a compiled checkout of
                        PHP's master branch (currently 7.1-dev).

pear-horde-5.2:         Installs the current Horde Groupware Webmail Edition
                        running on PHP 5.5.

pear-horde-cyrus-5.2:   Same as pear-horde-5.2, but running Cyrus instead of
                        instead of Dovecot and setup for Kolab.

pear-horde-mariadb-5.2: Same as pear-horde-5.2, but running MariaDB instead of
                        mySql.

pear-horde-php54-5.2:   Same as pear-horde-5.2, but running on PHP 5.4.

Note: the two oracle images require a bit of setup to use correctly, and they
only include client libraries, not the server. The libraries required cannot be
distributed. These images are here for my use. You are free to use them if you
set them up correctly, but don't expect them to work out of the box.



@TODO:

Some files need to be present in /vagrant, but really should be shared. We
should store them in shared, but copy them to /vagrant instead of placing them
in individual /setup/* folders.