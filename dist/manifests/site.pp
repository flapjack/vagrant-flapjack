
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

node default {
  if $operatingsystem in [ 'Ubuntu', 'Debian' ] {
    class { 'apt':
      always_apt_update => true,
      before => Class['nagios']
    }
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    include epel
    include repoforge
  }
  else {
    fail 'Everything else unsupported'
  }

  $ruby_json = $operatingsystem ? {
    /(Ubuntu|Debian)/ => 'ruby-json',
    /(CentOS|RedHat)/ => 'rubygem-json',
    default           => 'ruby-json',
  }

  package { 'curl':
    ensure => present
  } ->

  class {'nagios': } ->
  class {'icinga': } ->
  class {'flapjack': }

  if $tutorial_mode == 'true' {
    class {'flapjack-diner': }
  }

  class { 'rabbitmq':
  } ->

  rabbitmq_vhost { '/sensu':
    ensure => present,
  } ->

  rabbitmq_user { 'sensu':
    admin    => false,
    password => 'tangymango5',
  } ->

  rabbitmq_user_permissions { 'sensu@/sensu':
    configure_permission => '.*',
    read_permission      => '.*',
    write_permission     => '.*',
  } ->

  package { $ruby_json:
    ensure => present
  } ->

  class { 'redis': } ->

  class { 'sensu':
    rabbitmq_password => 'tangymango5',
    server            => true,
    api               => true,
    plugins           => [
      'puppet:///data/sensu/plugins/ntp.rb',
    ]
  }

  sensu::handler { 'default':
    command => 'mail -s \'sensu alert\' ops@example',
  }

  sensu::check { 'check_ntp':
    command     => 'PATH=$PATH:/usr/lib/nagios/plugins check_ntp_time -H pool.ntp.org -w 30 -c 60',
    handlers    => 'default',
    subscribers => 'sensu-test'
  }
}
