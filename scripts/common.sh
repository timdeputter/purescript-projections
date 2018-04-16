#!/usr/bin/env bash

set -e

echo 'Installing common Ubuntu components...'

sudo apt-get -y update

sudo apt-get -y install build-essential 
