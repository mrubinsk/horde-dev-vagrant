horde-dev-vagrant
=================

I've transitioned to using mostly nginx in my stack, and have finally started
updating these boxes to reflect my personal development environments. This
means that the main 'git-tools' and 'pear-horde-5.2' boxes are now based on
nginx and PHP 7.3-FPM. The provisioning scripts for the other PHP and webserver
options are still present in the the /shared folder and can easily be switched
out in the Vagrantfile.

If you are looking for the older configurations, including the legacy monolithic
repository boxes, they have moved to the DEPRECATED branch.

Vagrant images for Horde. Requires Vagrant 2.2. These should be considered for
DEVELOPMENT use only, or as a starting point for a more complete Vagrant image.

Usage:
  - change to the desired setup/* directory
  - Inspect Vagrantfile and/or config files and change as needed.
  - Run "vagrant up". That's it.
    - To destroy, run "vagrant destroy"

Notes:

    - All images based on Ubuntu boxes. See below for specific versions.

    - Installs either MySQL or MariaDB,
      Dovecot or Cyrus, and Postfix (configured for local delivery only).
      Email can be sent between any local users using e.g., testuser@localhost

    - PHP 7.3 is used by the default git-tools and pear-horde-5.2 boxes. Other
      boxes are as described. This can be changed to PHP - 5.4, 5.5, 5.6,
      or 7.0. This is selected by choosing the shared/phpxx.sh file desired in
      the Vagrantfile of the image.

    - For the Git images, the source tree is installed to /vagrant/horde/src
      and is therefore shared by the host OS, so editing and managing git from
      outside the VM is possible. Note that while you can execute git commands
      from outside the VM, using horde-git-tools from the shared directory
      will not work without a different configuration file since the paths are
      different...and the 'dev' commands won't work at all since they operate
      on the horde webroot, inside the VM.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
       - guest/guest
       - adminuser/adminpassword

    - On most of the boxes, Horde is reachable on port 8080 of the host running
      the virtual image. You will probably want to change this for your needs.
      The 'git-tools-master' image runs on public_network on port 80 by default
      since I often use this to test ActiveSync connectivity.
      This can be changed by changing the network config in the Vagrantfile
      of the image. If you change this setting you may also need to change
      Horde's config/conf.php file as well to point to the correct IP and/or
      Port.

    - For the Git images, any change to base configurations may require
      corresponding changes to various horde config files. E.g., changing the
      administive user/password will require corresponding change in imp's
      backend file for cyrus etc...

     - A minimal configuration is provided by default for the git images.
       Enough to get Horde running. You should review the config for your needs.

Following are the available images.

git-tools-master:               Current Git master. Ubuntu Bionic, Nginx,
                                PHP 7.3

git-tools-stable:               Current git stable branch; currently
                                FRAMEWORK_5_2.

pear-horde-5.2:                 Installs the current Horde Groupware Webmail
                                Edition on Ubuntu Bionic, PHP 7.3.

pear-horde-5.2-php54:           Installs the current Horde Groupware Webmail
                                Edition on Ubuntu Precise, PHP 5.4 and Apache.

pear-horde-5.2-php56:           Installs the current Horde Groupware Webmail
                                Edition on Ubuntu Trusty, PHP 5.6 and Apache.


pear-horde-5.2-php56-cyrus:     Same as pear-horde-5.2-php56, but running Cyrus
                                instead of instead of Dovecot and setup for
                                Kolab.

pear-horde-5.2.-php56-mariadb: Same as pear-horde-5.2, but running MariaDB
                              instead of mySql.

Note: the oracle image require a bit of setup to use correctly, and they
only include client libraries, not the server. The libraries required cannot be
distributed. These images are here for my use. You are free to use them if you
set them up correctly, but don't expect them to work out of the box.

