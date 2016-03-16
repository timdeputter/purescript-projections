#!/usr/bin/env bash

set -e

echo 'Installing the Haskell platform...'

as_vagrant='sudo -u vagrant -H bash -l -c'
home='/home/vagrant'
profile="$home/.bash_profile"
sudo -u vagrant touch $profile

apt-get -y update

apt-get -y install \
  haskell-platform \
  haskell-platform-doc \
  haskell-platform-prof \
  cabal-install

$as_vagrant 'cabal update'

if ! grep -q "/.cabal/bin/" $profile; then
  $as_vagrant "echo 'export PATH=$home/.cabal/bin/:$PATH' >> $profile"
fi
