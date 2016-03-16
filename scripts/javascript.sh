#!/usr/bin/env bash

set -e

echo 'Installing JavaScript development tools...'

sudo curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install npm -g

sudo npm install -g grunt grunt-cli
sudo npm install -g bower
