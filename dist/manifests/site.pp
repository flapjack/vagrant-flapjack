
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

node default {
  if $operatingsystem == 'Ubuntu' {
    class { 'apt':
      always_apt_update => true,
      before => Class['icinga']
    }
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    include epel
    include repoforge
  }
  else {
    fail 'Everything else unsupported'
  }

  package { 'curl':
    ensure => present
  } ->

  class {'icinga': }
  class {'nagios': }
  class {'flapjack': }

  if $tutorial_mode == 'true' {
    class {'flapjack-diner': }
  }

  #class { 'sensu':
  #  rabbitmq_password => 'sausage',
  #  server            => true,
  #  api               => true,
  #  plugins           => [
  #    'puppet:///data/sensu/plugins/ntp.rb',
  #  ]
  #}

  #sensu::handler { 'default':
  #  command => 'mail -s \'sensu alert\' ops@example',
  #}

  #sensu::check { 'check_ntp':
  #  command     => 'PATH=$PATH:/usr/lib/nagios/plugins check_ntp_time -H pool.ntp.org -w 30 -c 60',
  #  handlers    => 'default',
  #  subscribers => 'sensu-test'
  #}
}
