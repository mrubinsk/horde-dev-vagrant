#!/usr/bin/expect
spawn $env(HORDEDIR)/pear/pear -c $env(HORDEDIR)/pear.conf run-scripts horde/horde_role
expect {Filesystem location for the base Horde application :}
send "$env(HORDEDIR)\r"
expect eof
