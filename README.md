vagrant-flapjack
================

Easy to use demo of Flapjack managed with Vagrant

Dependencies
------------

- Vagrant
- VirtualBox or VMware Fusion
- (optional) vagrant-cachier - `vagrant plugin install vagrant-cachier`
  - caches packages so any subsequent `vagrant up` will use cached packages, and therefore be much faster if you're not on a super fast internet link.

Running
-------

```bash
git clone https://github.com/flapjack/vagrant-flapjack.git
cd vagrant-flapjack
```

Flapjack Vagrant currently supports both Ubuntu Precise and Ubuntu Trusty.  To choose your version, use one of the following to export the ubuntu_version environment variable.  The default is currently Ubuntu Precise.

```bash
export ubuntu_version='precise'
export ubuntu_version='trusty'
```

Flapjack Vagrant can install either the latest main experimental package from a given release.  To choose your component and release export the following variables.   The default is the v1 main release.

```bash
export component='experimental'
export flapjack_major_version='v1'
# Or if you want to use the 0.9 series:
export flapjack_major_version='0.9'
```

Then, start the vagrant instance:

```bash
vagrant up
```

Note: A `vagrant up` will look to see if the `VAGRANT_CACHE` environment variable is set, and enable the use of the vagrant-cachier plugin (or other cache plugin that may be installed) if it is.

To make use of the cache:

```bash
VAGRANT_CACHE=yes vagrant up
```

If you get some errors during package installation that look like corrupt package files or similar, you may want to disable the caching by running `vagrant up` without the `VAGRANT_CACHE=yes` bit.

Accessing
---------

Production:

- Flapjack: [http://localhost:3080/](http://localhost:3080/)
- Flapjack API: [http://localhost:3081/](http://localhost:3081/)
- Resque: [http://localhost:3082/](http://localhost:3082/)
- Nagios: [http://localhost:3083/](http://localhost:3083/nagios3/) user: nagiosadmin pass: nagios
- Icinga: [http://localhost:3083/](http://localhost:3083/icinga/) user: icingaadmin pass: icinga

Usage
-----

Flapjack, Redis, Icinga and Nagios should all be running after `vagrant up` completes, you can access their web interfaces with the links above. To poke around further, ssh into the VM:

`vagrant ssh`

Icinga is configured to feed its events to Flapjack using flapjackfeeder. If you want to also enable Nagios to feed its events to Flapjack, you can enable the flapjackfeeder event broker module like so:

```
vagrant-flapjack$ vagrant ssh
vagrant@flapjack:~$ sudo sed -i 's!#broker_module=/usr/local/lib/flapjackfeeder!broker_module=/usr/local/lib/flapjackfeeder!' /etc/nagios3/nagios.cfg
vagrant@flapjack:~$ sudo service nagios3 restart
```

Testing
-------

Flapjack packages now have testing, using both serverspec and capybara.  The serverspec tests will bring up the vagrant image if it isn't already up.

To run all the tests, run:

```bash
bundle exec rake
```

To run the serverspec or capybara tests separately, run:
```bash
bundle exec rake serverspec
bundle exec rake capybara
```
