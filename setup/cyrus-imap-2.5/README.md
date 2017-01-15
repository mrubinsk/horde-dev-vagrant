Cyrus-Imap Image
=================

Vagrant image for setting up a Cyrus IMAP 2.5 server suitable for running
against Horde's Kolab/Imap support.  Creates/configures required Kolab
annotations.

This image does NOT install Horde - just the Cyrus backend.

Usage:
  - Run "vagrant up". That's it.
  - To destroy, run "vagrant destroy"

Notes:
    - The server is reachable on 192.168.1.52

    - Based on Ubuntu Yakkety64.

    - The following users are created - username and passwords can be changed
      by editing the shared/conf.sh file:
       - demo/demo
       - guest/guest
       - adminuser/adminpassword