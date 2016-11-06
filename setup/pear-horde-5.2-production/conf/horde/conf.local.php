<?php
$conf['spell']['params']['path'] = '/usr/bin/aspell';
$conf['spell']['driver'] = 'aspell';
$conf['cookie']['domain'] = '';
$conf['cookie']['path'] = '/';

# SQL AUTH
$conf['auth']['list_users'] = 'list';
$conf['auth']['params']['phptype'] = 'mysql';
$conf['auth']['params']['socket'] = '/var/run/mysqld/mysqld.sock';
$conf['auth']['params']['protocol'] = 'unix';
$conf['auth']['params']['username'] = 'mailuser';
$conf['auth']['params']['password'] = 'mailpassword';
$conf['auth']['params']['database'] = 'mail';
$conf['auth']['params']['query_auth'] = 'SELECT * FROM mailbox WHERE uid = \L AND pwd = \P';
$conf['auth']['params']['query_add'] = 'INSERT INTO mailbox (uid,pwd) VALUES (\L, \P)';
$conf['auth']['params']['query_getpw'] = 'SELECT pwd FROM mailbox WHERE uid = \L';
$conf['auth']['params']['query_update'] = 'UPDATE mailbox SET uid = \L, pwd = \P WHERE uid = \O';
$conf['auth']['params']['query_resetpassword'] = 'UPDATE mailbox SET pwd = \P WHERE uid = \L';
$conf['auth']['params']['query_remove'] = 'DELETE FROM mailbox WHERE uid = \L';
$conf['auth']['params']['query_list'] = 'SELECT uid FROM mailbox';
$conf['auth']['params']['query_exists'] = 'SELECT 1 FROM mailbox WHERE uid = \L';
$conf['auth']['params']['encryption'] = 'crypt-sha512';
$conf['auth']['params']['show_encryption'] = false;
$conf['auth']['driver'] = 'customsql';