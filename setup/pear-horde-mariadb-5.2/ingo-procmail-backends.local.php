<?php
$backends['imap']['disabled'] = true;
$backends['procmail']['disabled'] = false;
$backends['procmail']['transport'][Ingo::RULE_ALL]['params']['delivery_mailbox_prefix'] = 'mail/';
