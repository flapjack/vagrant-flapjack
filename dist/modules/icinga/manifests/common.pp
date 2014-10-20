# installs and configures icinga
class icinga::common {
  if $operatingsystem == 'Ubuntu' {
    $icinga_version = $lsbdistrelease ? {
          12.04   => '1.6',
          14.04   => '1.10',
          default => '1.10',
    }
    $config_file = "icinga.${icinga_version}.debian.cfg"
    puts $config_file
    $external_dir = '/var/lib/nagios3/rw'
    $web_user = 'www-data'

    file { '/etc/nagios':
      ensure  => link,
      target  => '/etc/icinga',
      require => [ Package['icinga'] ],
    }
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    $icinga_version = $operatingsystemmajrelease ? {
          6       => '1.8',
          default => '1.8',
    }
    $config_file = "icinga.${icinga_version}.redhat.cfg"
    $external_dir = '/var/spool/icinga/cmd'
    $web_user = 'apache'

    user { $web_user:
      name    => $web_user,
      ensure  => 'present',
      comment => 'Apache',
      home    => '/var/www',
      shell   => '/sbin/nologin',
      system  => true
    }
  }
  else {
    fail 'Everything else unsupported'
  }

  $binary = 'icinga'

  package { $binary:
    ensure  => present,
    require => Class['repoforge']
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

  file { $external_dir:
    ensure  => directory,
    owner => nagios,
    group => $web_user,
    mode => 2750,
    require => [ Package['icinga'] ],
  }

  exec { 'fix-group-icinga.cmd':
    path => "/bin:/usr/bin",
    command => "chgrp ${web_user} ${external_dir}/nagios.cmd",
    onlyif => "/usr/bin/test `stat -c \"%G\" ${external_dir}/nagios.cmd` != ${web_user}",
    require => [ Package['icinga'] ],
  }

}
