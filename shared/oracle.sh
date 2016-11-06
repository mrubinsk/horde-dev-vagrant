echo "Installing alien."
apt-get install -y alien libaio1

echo "Installing Oracle client libraries."
alien -i /vagrant/oracle-instantclient12.1-basic-12.1.0.2.0-1.x86_64.rpm
alien -i /vagrant/oracle-instantclient12.1-sqlplus-12.1.0.2.0-1.x86_64.rpm
alien -i /vagrant/oracle-instantclient12.1-devel-12.1.0.2.0-1.x86_64.rpm


echo "Linking"
touch /etc/profile.d/oracle.sh
chmod o+r /etc/profile.d/oracle.sh
echo -e 'export ORACLE_HOME=/usr/lib/oracle/12.1/client64' | sudo tee -a /etc/profile.d/oracle.sh
echo -e 'export PATH=$PATH:$ORACLE_HOME/bin' | sudo tee -a /etc/profile.d/oracle.sh

touch /etc/ld.so.conf.d/oracle.conf
chmod o+r /etc/ld.so.conf.d/oracle.conf
echo -e '/usr/lib/oracle/12.1/client64/lib/' | sudo tee -a /etc/ld.so.conf.d/oracle.conf
ldconfig

echo "Installing PHP oci8 extension (for PHP 5.5)."
printf "instantclient,/usr/lib/oracle/12.1/client64/lib/\n" | pecl install oci8-2.0.11

echo -e 'extension=oci8.so' | sudo tee -a /etc/php5/cli/php.ini
echo -e 'extension=oci8.so' | sudo tee -a /etc/php5/apache2/php.ini