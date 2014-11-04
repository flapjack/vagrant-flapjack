# installs and configures icinga
class icinga::common {
  if $operatingsystem in [ 'Ubuntu', 'Debian' ] {
    $icinga_version = $lsbdistcodename ? {
      precise => '1.6',
      trusty  => '1.10',
      wheezy  => '1.6',
      default => '1.10'
    $icinga_version = $lsbdistrelease ? {
          12.04   => '1.6',
          14.04   => '1.10',
          default => '1.10',
    }
    $config_file = "icinga.${icinga_version}.debian.cfg"
    $web_user = 'www-data'
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    $icinga_version = $operatingsystemmajrelease ? {
          6       => '1.8',
          default => '1.8',
    }
    $config_file = "icinga.${icinga_version}.redhat.cfg"
    $web_user = 'apache'
  }
  else {
    fail 'Everything else unsupported'
  }

  $binary = 'icinga'

  package { $binary:
    ensure  => present,
  }

  service { $binary:
    ensure  => running,
  }

  file { "/etc/${binary}/icinga.cfg":
    source  => "puppet:///modules/icinga/etc/icinga/${config_file}",
    owner   => root,
    group   => root,
    mode    => '0644',
    require => Package['icinga'],
    notify  => Service['icinga'],
  }

  file { "/etc/${binary}/htpasswd.users":
    source  => 'puppet:///modules/icinga/etc/icinga/htpasswd.users',
    owner   => root,
    group   => $web_user,
    mode    => '0640',
    require => Package['icinga'],
    notify  => Service['icinga'],
  }
}
