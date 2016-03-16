#!/usr/bin/env bash

set -e

echo 'Installing common Ubuntu components...'

# not necessarily needed here, but a handy reference
as_vagrant='sudo -u vagrant -H bash -l -c'
home='/home/vagrant'
profile="$home/.bash_profile"
sudo -u vagrant touch $profile

apt-get -y update
apt-get -y upgrade
apt-get -y purge --auto-remove puppet
apt-get -y purge --auto-remove chef 

apt-get -y install \
  build-essential \
  libncurses5-dev \
  ack-grep \
  git \
  vim \
  emacs \
  bash-completion 
