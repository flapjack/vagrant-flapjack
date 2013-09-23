class flapjack::stats {
  file { '/etc/collectd/conf.d/flapjack.conf':
    source  => 'puppet:///flapjack/etc/collectd/conf.d/flapjack.conf',
    mode    => '0644',
    owner   => root,
    group   => root,
    notify  => [
      Service['collectd'],
    ],
    require => [
      Package['collectd'],
      File['/etc/collectd/conf.d'] ,
    ]
  }
}
