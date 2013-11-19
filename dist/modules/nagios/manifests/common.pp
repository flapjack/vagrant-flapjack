# installs and configures nagios
class nagios::common {

  package { 'nagios3':
    ensure  => present,
  }

  service { 'nagios3':
    ensure  => running,
  }

  # nagios configuration
  file { '/etc/nagios3/nagios.cfg':
    source  => 'puppet:///modules/nagios/etc/nagios3/nagios.cfg',
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

#  # prepare for flapjack-nagios-receiver
#  file { '/var/cache/icinga':
#    ensure  => directory,
#    owner   => 'nagios',
#    group   => 'www-data',
#    mode    => '2755',
#    require => Package['nagios3'],
#    before  => [
#      Exec['event_stream_fifo'],
#    ],
#  }
#
#  exec { 'event_stream_fifo':
#    command => '/usr/bin/mkfifo --mode=0666 /var/cache/icinga/event_stream.fifo',
#    unless  => 'test -p /var/cache/icinga/event_stream.fifo',
#    require => [
#      Package['icinga'],
#      File['/var/cache/icinga'],
#    ],
#  }

}
