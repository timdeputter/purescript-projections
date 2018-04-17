#!/usr/bin/env bash

set -e

echo 'Installing JavaScript development tools...'

sudo curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | bash
sudo nvm install node
sudo npm install npm@latest -g
