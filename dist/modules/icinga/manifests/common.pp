# installs and configures icinga
class icinga::common {

  package { 'icinga':
    ensure  => present,
  }

  service { 'icinga':
    ensure  => running,
  }

  # icinga configuration
  $icinga_version = $lsbdistrelease ? {
    12.04   => '1.6',
    14.04   => '1.10',
    default => '1.10',
  }
  file { '/etc/icinga/icinga.cfg':
    source  => "puppet:///modules/icinga/etc/icinga/${icinga_version}.icinga.cfg",
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

  file { '/var/lib/nagios3/rw':
    ensure  => directory,
    owner => nagios,
    group => www-data,
    mode => 2750,
    require => [ Package['icinga'] ],
  }

  exec { 'fix-group-icinga.cmd':
    path => "/bin:/usr/bin",
    command => 'chgrp www-data /var/lib/nagios3/rw/nagios.cmd',
    onlyif => '/usr/bin/test `stat -c "%G" /var/lib/nagios3/rw/nagios.cmd` != www-data',
    require => [ Package['icinga'] ],
  }

}
