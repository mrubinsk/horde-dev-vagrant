echo 'Setting ENV variables specific to dev install.'

# Set to false to skip installing Horde if you just need a Cyrus backend to
# test against an existing Horde install.
echo "export INSTALL_HORDE=true" >> ~/.profile

# Set to "deep" or "shallow"
echo "export GIT_DEPTH=shallow" >> ~/.profile