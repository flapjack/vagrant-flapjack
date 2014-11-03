# installs and configures nagios
class nagios::common {
  if $operatingsystem in [ 'Ubuntu', 'Debian' ] {
    $binary = 'nagios3'
    $nagios_version = $lsbdistrelease ? {
      12.04   => '3.2',
      14.04   => '3.5',
      default => '3.5'
    }
    $config_file = "nagios.${nagios_version}.debian.cfg"
    $web_user = 'www-data'
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    $binary = 'nagios'
    $nagios_version = $lsbdistrelease ? {
          6       => '3.5',
          default => '3.5',
    }
    $config_file = "nagios.${nagios_version}.redhat.cfg"
    $web_user = 'apache'
  }
  else {
    fail 'Everything else unsupported'
  }

  package { $binary:
    ensure  => present,
    require => Class['epel']
  }

  service { $binary:
    ensure  => running
  }

  file { "/etc/${binary}/nagios.cfg":
    source  => "puppet:///modules/nagios/etc/nagios3/${config_file}",
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package[$binary],
    notify  => Service[$binary]
  }

  file { "/etc/${binary}/htpasswd.users":
    source  => 'puppet:///modules/nagios/etc/nagios3/htpasswd.users',
    owner   => root,
    group   => $web_user,
    mode    => '0640',
    require => Package[$binary],
    notify  => Service[$binary]
  }

}
