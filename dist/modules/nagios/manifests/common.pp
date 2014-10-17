# installs and configures nagios
class nagios::common {
  $nagios = $operatingsystem ? {
      CentOS  => 'nagios',
      RedHat  => 'nagios',
      Ubuntu  => 'nagios3',
      default => 'nagios'
    }

  package { $nagios:
    ensure  => present
  }

  service { $nagios:
    ensure  => running
  }

  # nagios configuration
  $nagios_version = $lsbdistrelease ? {
    12.04   => '3.2',
    14.04   => '3.5',
    default => '3.5'
  }
  file { '/etc/nagios3/nagios.cfg':
    source  => "puppet:///modules/nagios/etc/nagios3/${nagios_version}.nagios.cfg",
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package[$nagios],
    notify  => Service[$nagios]
  }

  file { '/etc/nagios3/htpasswd.users':
    source  => 'puppet:///modules/nagios/etc/nagios3/htpasswd.users',
    owner   => root,
    group   => www-data,
    mode    => '0640',
    require => Package[$nagios],
    notify  => Service[$nagios]
  }

}
