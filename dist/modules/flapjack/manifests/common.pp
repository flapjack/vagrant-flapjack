# flapjack installation
class flapjack::common {

  include ruby::rubygems

  $version = 'latest'

  package { 'flapjack/1.9.3-p125':
    ensure   => $version,
    provider => rbenvgem,
    require  => [ Ruby::Version['1.9.3-p125'], ],
  }

  file { '/var/run/flapjack':
    ensure  => directory,
    mode    => '0777',
    require => [ Package['flapjack/1.9.3-p125'] ],
  }

  file { '/var/log/flapjack':
    ensure  => directory,
    mode    => '0777',
    require => [ Package['flapjack/1.9.3-p125'] ],
  }

  file { '/etc/flapjack':
    ensure  => directory,
    require => [ Package['flapjack/1.9.3-p125'] ],
  }

  exec { 'symlink-flapjack-gem':
    command => "ln -snf $(dirname $(dirname $(dirname $(/opt/rbenv/versions/1.9.3-p125/bin/gem which flapjack/patches)))) /usr/lib/flapjack",
    path    => '/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin',
    unless  => "readlink /usr/lib/flapjack | grep -E '${version}$'",
    require => [ Package['flapjack/1.9.3-p125'] ]
  }

  file { '/etc/flapjack/flapjack-config.yaml':
    source  => [
      "puppet:///modules/flapjack/etc/flapjack/flapjack-config.yaml.${::fqdn}",
      "puppet:///modules/flapjack/etc/flapjack/flapjack-config.yaml.${::clientid}",
      'puppet:///modules/flapjack/etc/flapjack/flapjack-config.yaml',
    ],
    require => [ Package['flapjack/1.9.3-p125'] ]
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
