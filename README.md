vagrant-flapjack
================

Easy to use demo of Flapjack managed with Vagrant

Dependencies
------------

- Vagrant
- VirtualBox or VMware Fusion

Running
-------

```
git clone https://github.com/flpjck/vagrant-flapjack.git
cd vagrant-flapjack
vagrant up
```

Accessing
---------

Production:

- Flapjack: [http://localhost:3080/](http://localhost:3080/)
- Flapjack API: [http://localhost:3081/](http://localhost:3081/)
- Resque: [http://localhost:3082/](http://localhost:3082/)
- Nagios: [https://localhost:3083/](https://localhost:3084/nagios3/) user: nagiosadmin pass: nagios
- Icinga: [https://localhost:3083/](https://localhost:3084/icinga/) user: icingaadmin pass: icinga

Usage
-----

To enable the flapjackfeeder event broker module in nagios/icinga do the following:

```
vagrant-flapjack$ vagrant ssh                                        
vagrant@flapjack:~$ sudo sed -i 's!#broker_module=/usr/local/lib/flapjackfeeder!broker_module=/usr/local/lib/flapjackfeeder!' /etc/nagios3/nagios.cfg 
vagrant@flapjack:~$ sudo sed -i 's!#broker_module=/usr/local/lib/flapjackfeeder!broker_module=/usr/local/lib/flapjackfeeder!' /etc/icinga/icinga.cfg  
vagrant@flapjack:~$ sudo service nagios3 restart
vagrant@flapjack:~$ sudo service icinga restart
```
