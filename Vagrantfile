# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box      = 'precise64'
  config.vm.box_url  = 'http://files.vagrantup.com/precise64.box'
  config.vm.hostname = 'flapjack.example.org'

  config.vm.network "forwarded_port", guest: 80,   host: 3083
  config.vm.network "forwarded_port", guest: 443,  host: 3084
  config.vm.network "forwarded_port", guest: 3080, host: 3080
  config.vm.network "forwarded_port", guest: 3081, host: 3081
  config.vm.network "forwarded_port", guest: 3082, host: 3082
  config.vm.network "forwarded_port", guest: 4080, host: 4080
  config.vm.network "forwarded_port", guest: 4081, host: 4081
  config.vm.network "forwarded_port", guest: 4082, host: 4082
  config.vm.network "forwarded_port", guest: 5222, host: 5222
  config.vm.network "forwarded_port", guest: 5280, host: 5280

  config.ssh.forward_agent = true

  config.vm.provision :puppet do |puppet|
    puppet.module_path    = 'dist/modules'
    puppet.manifests_path = 'dist/manifests'
    puppet.manifest_file  = 'site.pp'
  end

  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["setextradata", :id, "VBoxInternal/Devices/mc146818/0/Config/UseUTC", 1]
  end
end

