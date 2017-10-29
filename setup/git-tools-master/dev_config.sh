echo 'Setting ENV variables specific to dev install.'

# Set to "deep" or "shallow"
echo "export GIT_DEPTH=shallow" >> ~/.profile

# Path to horde source code.
echo "export HORDESRC=/horde/src" >> ~/.profile

# horde-git-tools location
echo "export HORDETOOLS=/horde/tools" >> ~/.profile

# Default vagrant user name
echo "export VAGRANTUSER=vagrant" >> ~/.profile
