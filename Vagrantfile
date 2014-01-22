# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box      = 'precise64'
  config.vm.box_url  = 'http://files.vagrantup.com/precise64.box'
  config.vm.hostname = 'flapjack.example.org'
  config.vm.define :flapjack do |t|
  end

  config.vm.network "forwarded_port", guest: 80,   host: 3083, auto_correct: true
  config.vm.network "forwarded_port", guest: 443,  host: 3084, auto_correct: true
  config.vm.network "forwarded_port", guest: 3071, host: 3071, auto_correct: true
  config.vm.network "forwarded_port", guest: 3080, host: 3080, auto_correct: true
  config.vm.network "forwarded_port", guest: 3081, host: 3081, auto_correct: true
  config.vm.network "forwarded_port", guest: 3082, host: 3082, auto_correct: true
  config.vm.network "forwarded_port", guest: 5222, host: 5222, auto_correct: true
  config.vm.network "forwarded_port", guest: 5280, host: 5280, auto_correct: true

  config.ssh.forward_agent = true

  config.vm.provision :puppet do |puppet|
    puppet.module_path    = 'dist/modules'
    puppet.manifests_path = 'dist/manifests'
    puppet.manifest_file  = 'site.pp'
  end

  using_virtualbox = false
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 1024]
    v.customize ["setextradata", :id, "VBoxInternal/Devices/mc146818/0/Config/UseUTC", 1]
  end

  # to speed up subsequent rebuilds install vagrant-cachier
  # to cache packages in your ~/.vagrant.d/cache directory
  # https://github.com/fgrehm/vagrant-cachier
  #   `vagrant plugin install vagrant-cachier`
  if ENV['VAGRANT_CACHE']
    config.cache.auto_detect = true
    #config.cache.enable_nfs  = true
  end
end

