# sets up flapjack-nagios-receiver
class flapjack::nagios_receiver {
  include flapjack::common

  service { 'flapjack-nagios-receiver':
    ensure    => running,
    enable    => true,
    require   => [
      Package['flapjack/1.9.3-p125'],
      File['/etc/init.d/flapjack-nagios-receiver'],
      File['/etc/monit/conf.d/flapjack-nagios-receiver'],
    ],
    subscribe => [ Package['flapjack/1.9.3-p125'], ],
  }

  file { '/etc/monit/conf.d/flapjack-nagios-receiver':
    source => [
      "puppet:///modules/flapjack/etc/monit/conf.d/flapjack-nagios-receiver.${::fqdn}",
      'puppet:///modules/flapjack/etc/monit/conf.d/flapjack-nagios-receiver',
    ],
    notify => [ Service['flapjack-nagios-receiver'] ],
  }

  file { '/etc/init.d/flapjack-nagios-receiver':
    source  => '/usr/lib/flapjack/dist/etc/init.d/flapjack-nagios-receiver',
    require => [ Exec['symlink-flapjack-gem'] ],
    notify  => [ Service['flapjack-nagios-receiver'] ],
  }

  # flapjackfeeder
  file { '/usr/local/lib':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    before  => File['/usr/local/lib/flapjackfeeder.o'],
  }

  file { '/usr/local/lib/flapjackfeeder.o':
    source  => 'puppet:///flapjack/usr/local/lib/flapjackfeeder.o',
    owner   => root,
    group   => root,
    mode    => '0644',
    notify  => Service['icinga'],
  }

}
