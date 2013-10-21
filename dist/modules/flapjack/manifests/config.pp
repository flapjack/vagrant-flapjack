class flapjack::config {
  file { '/var/run/flapjack':
    ensure  => directory,
    mode    => '0777',
    require => [ Package['flapjack'] ],
  }

  file { '/var/log/flapjack':
    ensure  => directory,
    mode    => '0777',
    require => [ Package['flapjack'] ],
  }

  file { '/etc/flapjack':
    ensure  => directory,
    require => [ Package['flapjack'] ],
  }

  file { '/etc/flapjack/flapjack-config.yaml':
    source  => 'puppet:///modules/flapjack/etc/flapjack/flapjack-config.yaml',
  }

  file { '/etc/init.d/flapjack-web-api':
    source  => 'puppet:///modules/flapjack/etc/init.d/flapjack-web-api',
  }

  logrotate::rule { 'flapjack-log':
    path          => '/var/log/flapjack/*.log',
    maxage        => 31,
    size          => '100M',
    dateext       => true,
    dateformat    => '.%Y%m%d',
    copy          => true,
    copytruncate  => true,
    compress      => true,
    compresscmd   => '/bin/bzip2',
    compressext   => '.bz2',
  }

  logrotate::rule { 'flapjack-output':
    path          => '/var/log/flapjack/*.output',
    maxage        => 31,
    size          => '100M',
    dateext       => true,
    dateformat    => '.%Y%m%d',
    copy          => true,
    copytruncate  => true,
    compress      => true,
    compresscmd   => '/bin/bzip2',
    compressext   => '.bz2',
  }

}
