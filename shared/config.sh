#!/usr/bin/env bash

echo 'Setting ENV variables'

# Path to web accessible directory for Horde.
echo "export HORDEDIR=/var/www/html/horde" >> ~/.profile

# Test users
echo "export TESTUSERONE=demo" >> ~/.profile
echo "export TESTUSERONEPASS=demo" >> ~/.profile

echo "export TESTUSERTWO=guest" >> ~/.profile
echo "export TESTUSERTWOPASS=guest" >> ~/.profile

# NOTE: MUST CHANGE THIS PASSWORD IF IMAGE IS PUBLIC!
echo "export ADMINUSER=adminuser" >> ~/.profile
echo "export ADMINUSERPASS=adminpassword" >> ~/.profile

# Password, if using MySQL.
echo "export MYSQLPASSWORD=password" >> ~/.profile

# Include the hooks to automatically create from_addr prefs.
echo "export INCLUDE_HOOKS=true" >> ~/.profile