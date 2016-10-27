#!/usr/bin/expect
#
#
spawn /usr/bin/cyradm -u vagrant -w vagrant localhost
expect {localhost>}
#
send "cm user.$env(TESTUSERONE)\r"
expect {localhost>}

send "cm user.$env(TESTUSERTWO)\r"
expect {localhost>}

send "cm user.$env(ADMINUSER)\r"
expect {localhost>}

#
send "exit\r"
expect eof
