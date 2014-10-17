#!/usr/bin/env bash

# Install Horde from source
apt-get install -y git
mkdir -p /horde/data
mkdir -p /horde/src
git clone --depth 1 https://github.com/horde/horde.git /horde/src

# Install framework
cp install_dev.conf /horde/src/framework/bin
/horde/src/framework/bin/install_dev

# Install Horde PEAR packages, so that we don't need to deal with those
# dependencies
/horde/src/framework/bin/pear_batch_install

# Now install optional/required PEAR/PECL packages
/horde/src/framework/bin/pear_batch_install -a \
	-p .,../content,../gollem,../horde,../imp,../ingo,../kronolith,../mnemo,../nag,../passwd,../timeobjects,../trean,../turba
