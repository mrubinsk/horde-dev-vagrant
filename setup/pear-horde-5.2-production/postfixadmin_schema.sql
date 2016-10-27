USE mail;

#
# Table structure for table domain
#
CREATE TABLE domain (
  id int(11) NOT NULL auto_increment,
  name varchar(255) NOT NULL default '',
  description varchar(255) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY domain (name)
);

#
# Table structure for table mailbox
#
CREATE TABLE mailbox (
  id int(11) NOT NULL auto_increment,
  domain_id int(11) NOT NULL,
  email varchar(100) NOT NULL,
  password varchar(255) NOT NULL default '',
  PRIMARY KEY  (id),
  UNIQUE KEY email (email)
);

CREATE TABLE alias (
  id int(11) NOT NULL auto_increment,
  domain_id int(11) NOT NULL,
  source varchar(100) NOT NULL,
  destination varchar(100) NOT NULL,
  PRIMARY KEY (id)
);