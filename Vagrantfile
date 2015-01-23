# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  distro_release         = ENV['distro_release'] || 'trusty'
  flapjack_component     = ENV['flapjack_component'] || 'main'
  flapjack_major_version = ENV['flapjack_major_version'] || 'v1'
  tutorial_mode          = ENV['tutorial_mode'] || false

  case distro_release
  when 'precise'
    config.vm.box      = 'hashicorp/precise64'
    config.vm.box_url  = 'https://vagrantcloud.com/hashicorp/precise64'
  when 'trusty'
    config.vm.box      = 'puppetlabs/ubuntu-14.04-64-puppet'
    config.vm.box_url  = 'https://vagrantcloud.com/puppetlabs/ubuntu-14.04-64-puppet'
  when 'wheezy'
    config.vm.box      = 'cargomedia/debian-7-amd64-default'
    config.vm.box_url  = 'https://vagrantcloud.com/cargomedia/debian-7-amd64-default'
  when 'centos-6'
    config.vm.box      = 'puppetlabs/centos-6.5-64-puppet'
    config.vm.box_url  = 'https://vagrantcloud.com/puppetlabs/boxes/centos-6.5-64-puppet'
    flapjack_component = flapjack_component == 'main' ? 'flapjack' : 'flapjack-experimental'
  when 'centos-7'
    config.vm.box      = 'puppetlabs/centos-7.0-64-puppet'
    config.vm.box_url  = 'https://vagrantcloud.com/puppetlabs/centos-7.0-64-puppet'
    flapjack_component = flapjack_component == 'main' ? 'flapjack' : 'flapjack-experimental'
  end

  config.vm.hostname = 'flapjack.example.org'
  config.vm.define :flapjack do |t|
  end

  config.vm.network "forwarded_port", guest: 3000,  host: 3000,  auto_correct: true
  config.vm.network "forwarded_port", guest: 3071,  host: 3071,  auto_correct: true
  config.vm.network "forwarded_port", guest: 3080,  host: 3080,  auto_correct: true
  config.vm.network "forwarded_port", guest: 3081,  host: 3081,  auto_correct: true
  config.vm.network "forwarded_port", guest: 3082,  host: 3082,  auto_correct: true
  config.vm.network "forwarded_port", guest: 80,    host: 3083,  auto_correct: true
  config.vm.network "forwarded_port", guest: 443,   host: 3084,  auto_correct: true
  config.vm.network "forwarded_port", guest: 5222,  host: 5222,  auto_correct: true
  config.vm.network "forwarded_port", guest: 5280,  host: 5280,  auto_correct: true
  config.vm.network "forwarded_port", guest: 15672, host: 15672, auto_correct: true

  config.ssh.forward_agent = true

  config.vm.provision :puppet do |puppet|
    puppet.module_path    = 'dist/modules'
    puppet.manifests_path = 'dist/manifests'
    puppet.manifest_file  = 'site.pp'
    # puppet.options        = "--verbose --debug"
    puppet.facter = {
      "flapjack_component"     => flapjack_component,
      "flapjack_major_version" => flapjack_major_version,
      "tutorial_mode"          => tutorial_mode
    }
  end

  using_virtualbox = false
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--memory", 2048]
    v.customize ["setextradata", :id, "VBoxInternal/Devices/mc146818/0/Config/UseUTC", 1]
  end

  # to speed up subsequent rebuilds install vagrant-cachier
  # to cache packages in your ~/.vagrant.d/cache directory
  # https://github.com/fgrehm/vagrant-cachier
  #   `vagrant plugin install vagrant-cachier`
  unless ENV['DISABLE_VAGRANT_CACHE']
    if Vagrant.has_plugin?("vagrant-cachier")
      # Configure cached packages to be shared between instances of the same base box.
      # More info on http://fgrehm.viewdocs.io/vagrant-cachier/usage
      config.cache.scope = :box
    end
  end
end
