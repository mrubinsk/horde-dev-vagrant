pirum-server
=================

Quick and dirty vagrant sandbox for provisioning a Pirum server.

Usage:
  - change to the desired setup/* directory
  - Run "vagrant up". That's it.
    - To destroy, run "vagrant destroy"

Notes:

    - Based on Ubuntu Trusty64 unless otherwise noted. Vagrantfile includes
      commented out directives for provision to Scaleway (org and token must
      be added).

    - Pirum served directly out of /var/www by lighttpd. Assumes the name of
      the channel is pear.horde.org and is reachable at
      http://testpear.horde.org. This can be changed by editing the pirum.xml
      file directly before provisioning the server.

    - Packages can be pushed to this server by the 'demo' user.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
