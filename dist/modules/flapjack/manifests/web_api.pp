# gets flapjack installed and ready to run the main process
class flapjack::web_api {
  include flapjack::common

  service { 'flapjack-web-api':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => false,
    start      => 'touch /tmp/puppet_no_start_flapjack_web_api_look_at_monit',
    require    => [
      Package['flapjack/1.9.3-p125'],
      File['/etc/init.d/flapjack-web-api'],
      File['/etc/flapjack/flapjack-config-web-api.yaml'],
      File['/etc/monit/conf.d/flapjack-web-api'],
    ],
    subscribe  => [
      Package['flapjack/1.9.3-p125'],
      File['/etc/flapjack/flapjack-config-web-api.yaml'],
    ]
  }

  file { '/etc/flapjack/flapjack-config-web-api.yaml':
    source  => [
      "puppet:///modules/flapjack/etc/flapjack/flapjack-config-web-api.yaml.${::fqdn}",
      "puppet:///modules/flapjack/etc/flapjack/flapjack-config-web-api.yaml.${::clientid}",
      'puppet:///modules/flapjack/etc/flapjack/flapjack-config-web-api.yaml',
    ],
    require => [ Package['flapjack/1.9.3-p125'] ]
  }

  file { '/etc/init.d/flapjack-web-api':
    source  => [ 'puppet:///modules/flapjack/etc/init.d/flapjack-web-api' ],
    require => [ Exec['symlink-flapjack-gem'] ],
    notify  => [ Service['flapjack'] ],
  }

  file { '/etc/monit/conf.d/flapjack-web-api':
    source => [
      "puppet:///modules/flapjack/etc/monit/conf.d/flapjack-web-api.${::fqdn}",
      'puppet:///modules/flapjack/etc/monit/conf.d/flapjack-web-api',
    ],
    notify => [ Service['monit'] ],
  }

}
