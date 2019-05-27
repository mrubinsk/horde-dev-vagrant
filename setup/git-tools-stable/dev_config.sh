echo 'Setting ENV variables specific to dev install.'

# Set to "deep" or "shallow"
echo "export GIT_DEPTH=deep" >> ~/.profile

# Horde master config
# HORDEDIR is defined in config.sh
echo "export HORDE_HOSTNAME=horde-stable.local" >> ~/.profile
echo "export HORDESRC=/vagrant/horde/src" >> ~/.profile

# horde-git-tools location
echo "export HORDETOOLS=/vagrant/horde/tools" >> ~/.profile

# Default vagrant user name
echo "export VAGRANTUSER=vagrant" >> ~/.profile

echo "export BRANCHNAME=FRAMEWORK_5_2" >> ~/.profile

