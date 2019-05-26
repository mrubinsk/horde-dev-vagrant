echo 'Setting ENV variables specific to dev install.'

# Set to "deep" or "shallow"
echo "export GIT_DEPTH=deep" >> ~/.profile

# Path to horde source code.
echo "export HORDESRC=/vagrant/horde/src-master" >> ~/.profile

# horde-git-tools location
echo "export HORDETOOLS=/vagrant/horde/tools" >> ~/.profile

# Default vagrant user name
echo "export VAGRANTUSER=vagrant" >> ~/.profile

# Match hostname from vagrantfile.
echo "export HORDE_HOSTNAME=horde-master.local" >> ~/.profile
