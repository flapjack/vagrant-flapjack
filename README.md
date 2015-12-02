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

Flapjack Vagrant currently supports the following Linux distro releases:
- `precise` - Ubuntu 12.04
- `trusty` - Ubuntu 14.04 (default)
- `wheezy` - Debian 7.7
- `centos-6` - CentOS 6

To choose the distro & release version, use one of the following to export the distro_release environment variable.

```bash
export distro_release='precise'
export distro_release='trusty'
export distro_release='wheezy'
export distro_release='centos-6'
```

Flapjack Vagrant can install either the latest *main* (default) or *experimental* package from a given major series.  To choose your component and major release export the following variables.   The default is the v1 main release.

```bash
export flapjack_component='experimental'
export flapjack_major_version='v1'

# Or if you want to use the 0.9 series:
export flapjack_major_version='0.9'
```

Then, start the vagrant instance:

```bash
vagrant up
```

If you get some errors during package installation that look like corrupt package files or similar, you may want to disable the caching by running `vagrant up` with the `DISABLE_VAGRANT_CACHE` environment variable set:

```bash
DISABLE_VAGRANT_CACHE=yes vagrant up
```

Optional Extras
---------------

* Tutorial Mode *

```bash
export tutorial_mode="true"
```

This installs the [Flapjack Diner](https://rubygems.org/gems/flapjack-diner) Ruby gem. It could be useful for running through tutorials. FIXME: is it useful / required for any published tutorials?

* With Sensu *

```bash
export with_sensu="true"
```

This will also install and configure Sensu along with its dependencies (RabbitMQ, OS's Redis).

If you already created your vm you can add Sensu by doing a provision, eg:

```bash
with_sensu="true" vagrant provision
```

Accessing
---------

Production:

- Flapjack: [http://localhost:3080/](http://localhost:3080/)
- Flapjack API: [http://localhost:3081/](http://localhost:3081/)
- Resque: [http://localhost:3082/](http://localhost:3082/) (if Flapjack v1)
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
bundle
rake
```

To run the serverspec or capybara tests separately, run:
```bash
rake serverspec
rake capybara
```

NOTE: for some reason you cannot use bundle exec with these commands. Not sure why. You get lots of errors like this one:

```
  1) Package "flapjack"
     On host ``
     Failure/Error: Unable to find matching line from backtrace
     NoMethodError: undefined method `source_location' for nil:NilClass

       undefined method `source_location' for nil:NilClass
     # ./spec/serverspec_spec_helper.rb:20:in `block (2 levels) in <top (required)>'
```

