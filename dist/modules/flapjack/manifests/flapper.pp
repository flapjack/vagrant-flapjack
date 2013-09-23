# sets up flapjack flapper
class flapjack::flapper {
  include flapjack::common

  service { 'flapper':
    ensure    => running,
    enable    => true,
    require   => [
      Package['flapjack/1.9.3-p125'],
      File['/etc/init.d/flapper'],
      File['/etc/monit/conf.d/flapper'],
    ],
    subscribe => [ Package['flapjack/1.9.3-p125'], ],
  }

  file { '/etc/monit/conf.d/flapper':
    source => [
      "puppet:///modules/flapjack/etc/monit/conf.d/flapper.${::fqdn}",
      'puppet:///modules/flapjack/etc/monit/conf.d/flapper',
    ],
    notify => [ Service['flapper'] ],
  }

  file { '/etc/init.d/flapper':
    source  => '/usr/lib/flapjack/dist/etc/init.d/flapper',
    require => [ Exec['symlink-flapjack-gem'] ],
    notify  => [ Service['flapper'] ],
  }

}
