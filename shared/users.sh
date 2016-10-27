#!/usr/bin/env bash

# Generate a test user.
if getent passwd $TESTUSERONE > /dev/null; then
    echo "$TESTUSERONE already exists"
else
    echo "Creating User '$TESTUSERONE' with password '$TESTUSERONEPASS'"
    sudo useradd $TESTUSERONE -m -s /bin/bash
    echo "$TESTUSERONE:$TESTUSERONEPASS"|sudo chpasswd
    echo 'User created'
fi

# Generate a test user.
if getent passwd $TESTUSERTWO > /dev/null; then
    echo "$TESTUSERTWO already exists"
else
    echo "Creating User '$TESTUSERTWO' with password '$TESTUSERTWOPASS'"
    sudo useradd $TESTUSERTWO -m -s /bin/bash
    echo "$TESTUSERTWO:$TESTUSERTWOPASS"|sudo chpasswd
    echo 'User created'
fi

# Generate the admin user.
if getent passwd $ADMINUSER > /dev/null; then
    echo "$ADMINUSER already exists"
else
    echo "Creating User '$ADMINUSER' with password '$ADMINUSERPASS'"
    sudo useradd $ADMINUSER -m -s /bin/bash
    echo "$ADMINUSER:$ADMINUSERPASS"|sudo chpasswd
    echo 'User created'
fi
