<?php
$conf['auth']['admins'] = array('adminuser');
$conf['auth']['checkip'] = true;
$conf['auth']['checkbrowser'] = true;
$conf['auth']['resetpassword'] = true;
$conf['auth']['alternate_login'] = false;
$conf['auth']['redirect_on_logout'] = false;
$conf['auth']['list_users'] = 'list';
$conf['auth']['params']['hostspec'] = 'localhost';
$conf['auth']['params']['port'] = 143;
$conf['auth']['params']['secure'] = 'tls';
$conf['auth']['driver'] = 'imap';
$conf['auth']['params']['count_bad_logins'] = false;
$conf['auth']['params']['login_block'] = false;
$conf['auth']['params']['login_block_count'] = 5;
$conf['auth']['params']['login_block_time'] = 5;