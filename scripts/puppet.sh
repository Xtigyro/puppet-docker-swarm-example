#!/bin/bash

red='\e[0;31m'
orange='\e[0;33m'
green='\e[0;32m'
end='\e[0m'


# if puppet is already installed do nothing
if which /usr/local/bin/puppet > /dev/null 2>&1; then
  echo -e "${orange}----> Puppet is aready installed${end}"
  exit 0
fi

# Update Pkg Manager Data
sudo apt-get update

# Install puppet/facter/ruby
echo -e "----> ${green}Installing Puppet and Ruby ${end}"
sudo apt-get install -y puppet facter ruby

#sudo gem update --system
#sudo gem install puppet -v 6.4.0
#sudo gem install facter