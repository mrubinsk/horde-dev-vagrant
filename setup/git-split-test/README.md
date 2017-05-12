git-split-test
=================

Vagrant sandbox for testing development tasks using the new split repository
structure and cooresponding toolchain.

Creates an entire Horde stack based on the individual git repositories.


Usage:
  - change to the desired setup/* directory
  - Run "vagrant up". That's it.
    - To destroy, run "vagrant destroy"

Notes:

    - Based on Ubuntu Trusty64 unless otherwise noted.

    - Installs MySQL, Dovecot, and Postfix (configured for local delivery only).
      Email can be sent between any local users using e.g., demor@localhost

    - PHP 7.1 is used by default.
      This can be changed to PHP - 5.4, 5.5, 5.6, or 7.0. This is selected
      by choosing the shared/phpxx.sh file desired in the Vagrantfile of the
      image.

    - Horde's web root is configured as /var/www/html/horde.
      The base of the source tree is configured as /horde/src.
      The git-tools package is installed in /horde/tools.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
       - guest/guest
       - adminuser/adminpassword

    - Horde is reachable on port 8080 of the localhost.
      This can be changed by changing the network config in the Vagrantfile
      of the image. If you change this setting you may also need to change
      Horde's config/conf.php file as well to point to the correct IP and/or
      Port.

    - NOTE: Any change to base configurations may require
      corresponding changes to various horde config files. E.g., changing the
      administive user/password will require corresponding change in imp's
      backend file etc...
