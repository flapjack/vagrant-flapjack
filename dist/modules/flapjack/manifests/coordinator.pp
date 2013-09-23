# gets flapjack installed and ready to run the main process
class flapjack::coordinator {
  include flapjack::common
  include monit

  service { 'flapjack':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => false,
    start      => 'touch /tmp/puppet_no_start_flapjack_look_at_monit',
    require    => [
      Package['flapjack/1.9.3-p125'],
      File['/etc/init.d/flapjack'],
      File['/etc/flapjack/flapjack-config.yaml'],
      File['/etc/monit/conf.d/flapjack'],
    ],
    subscribe  => [
      Package['flapjack/1.9.3-p125'],
      File['/etc/flapjack/flapjack-config.yaml'],
    ]
  }

  file { '/etc/init.d/flapjack':
    source  => [ 'puppet:///modules/flapjack/etc/init.d/flapjack' ],
    require => [ Exec['symlink-flapjack-gem'] ],
    notify  => [ Service['flapjack'] ],
  }

  file { '/etc/monit/conf.d/flapjack':
    source => [
      "puppet:///modules/flapjack/etc/monit/conf.d/flapjack.${::fqdn}",
      'puppet:///modules/flapjack/etc/monit/conf.d/flapjack',
    ],
    notify => [ Service['monit'] ],
  }

}
