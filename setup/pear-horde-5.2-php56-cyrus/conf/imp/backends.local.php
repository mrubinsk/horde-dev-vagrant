<?php
$servers['imap']['hordeauth'] = true;
$servers['imap']['secure'] = false;
$servers['imap']['port'] = 143;
$servers['imap']['cache'] = false;
$servers['imap']['admin'] = array(
    'user' => 'adminuser',
    'password' => 'adminuserpassword',
    'userhierarchy' => 'user.'
);
$servers['imap']['acl'] = true;
$servers['imap']['debug'] = '/tmp/imap.log';
$servers['imap']['debug_raw'] = true;