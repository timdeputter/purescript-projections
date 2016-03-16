# -*- mode: ruby -*-
# vi: set ft=ruby :

require 'vagrant/util/platform'

# Vagrantfile API/syntax version.
VAGRANTFILE_API_VERSION = '2'

# Load files in the support directory
#Dir.glob('support/**/*.rb').each {|file| load file }

# Vagrant configuration
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.define 'purejections', primary: true do |cfg|

    cfg.vm.box = 'ubuntu/trusty64'

    cfg.vm.provision :shell, :path => 'scripts/common.sh'
    cfg.vm.provision :shell, :path => 'scripts/haskell.sh'
    cfg.vm.provision :shell, :path => 'scripts/javascript.sh'
    cfg.vm.provision :shell, :path => 'scripts/purescript.sh'

    cfg.vm.provider 'virtualbox' do |v|
      v.name = 'purejections'
      v.memory = 2094
      v.cpus = 2
    end

  end
end
