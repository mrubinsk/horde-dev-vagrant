#!/usr/bin/env bash

echo 'Setting ENV variables'

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

# Use IMAP auth (default is Application/IMP).
# echo "export IMAP_AUTH=true" >> ~/.profile

