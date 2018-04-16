#!/usr/bin/env bash

set -e

echo 'Installing PureScript via npm...'
sudo npm install -g purescript --unsafe-perm=true
sudo npm install -g pulp bower
