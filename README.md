vagrant-flapjack
================

Easy to use demo of Flapjack managed with Vagrant

Dependencies
------------

- Vagrant
- VirtualBox or VMware Fusion
- (optional) vagrant-cachier - `vagrant plugin install vagrant-cachier`
  - caches packages so any subsequent `vagrant up` will use cached packages.

Running
-------

```bash
git clone https://github.com/flpjck/vagrant-flapjack.git
cd vagrant-flapjack
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

Flapjack, Redis, Icinga and Nagios should all be running after `vagrant up` completes, you can access their web interfaces with the links above.

Icinga is configured to feed its events to Flapjack using flapjackfeeder. If you want to also enable Nagios to feed its events to Flapjack, you can enable the flapjackfeeder event broker module like so:

```
vagrant-flapjack$ vagrant ssh
vagrant@flapjack:~$ sudo sed -i 's!#broker_module=/usr/local/lib/flapjackfeeder!broker_module=/usr/local/lib/flapjackfeeder!' /etc/nagios3/nagios.cfg
vagrant@flapjack:~$ sudo service nagios3 restart
```
