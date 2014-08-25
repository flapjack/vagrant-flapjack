# installs and configures nagios
class nagios::common {

  package { 'nagios3':
    ensure  => present,
  }

  service { 'nagios3':
    ensure  => running,
  }

  # nagios configuration
  $nagios_version = $lsbdistrelease ? {
    12.04   => '3.2',
    14.04   => '3.5',
    default => '3.5',
  }
  file { '/etc/nagios3/nagios.cfg':
    source  => "puppet:///modules/nagios/etc/nagios3/${nagios_version}.nagios.cfg",
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }

  file { '/etc/nagios3/htpasswd.users':
    source  => 'puppet:///modules/nagios/etc/nagios3/htpasswd.users',
    owner   => root,
    group   => www-data,
    mode    => '0640',
    require => Package['nagios3'],
    notify  => Service['nagios3'],
  }

}
