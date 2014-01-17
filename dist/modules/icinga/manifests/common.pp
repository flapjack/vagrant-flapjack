# installs and configures icinga
class icinga::common {

  package { 'icinga':
    ensure  => present,
  }

  service { 'icinga':
    ensure  => running,
  }

  # icinga configuration
  file { '/etc/icinga/icinga.cfg':
    source  => 'puppet:///modules/icinga/etc/icinga/icinga.cfg',
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['icinga'],
    notify  => Service['icinga'],
  }

  file { '/etc/icinga/htpasswd.users':
    source  => 'puppet:///modules/icinga/etc/icinga/htpasswd.users',
    owner   => root,
    group   => www-data,
    mode    => '0640',
    require => Package['icinga'],
    notify  => Service['icinga'],
  }

  file { '/etc/nagios':
    ensure  => link,
    target  => '/etc/icinga',
    require => [ Package['icinga'] ],
  }

  file { '/var/lib/icinga/rw':
    ensure  => directory,
    owner => nagios,
    group => www-data,
    mode => 2750,
    require => [ Package['icinga'] ],
  }

  exec { 'fix-group-icinga.cmd':
    path => "/bin:/usr/bin",
    command => 'chgrp www-data /var/lib/icinga/rw/icinga.cmd',
    onlyif => '/usr/bin/test `stat -c "%G" /var/lib/icinga/rw/icinga.cmd` != www-data',
    require => [ Package['icinga'] ],
  }

  # prepare for flapjack-nagios-receiver
  file { '/var/cache/icinga':
    ensure  => directory,
    owner   => 'nagios',
    group   => 'www-data',
    mode    => '2755',
    require => Package['icinga'],
    before  => [
      Exec['event_stream_fifo'],
    ],
  }

  exec { 'event_stream_fifo':
    command => '/usr/bin/mkfifo --mode=0666 /var/cache/icinga/event_stream.fifo',
    unless  => 'test -p /var/cache/icinga/event_stream.fifo',
    require => [
      Package['icinga'],
      File['/var/cache/icinga'],
    ],
  }

}
