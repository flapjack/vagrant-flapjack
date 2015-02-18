
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

  if $with_sensu == 'true' {
    class { 'rabbitmq':
    } ->

    rabbitmq_vhost { '/sensu':
      ensure => present,
    } ->

    rabbitmq_user { 'admin':
      admin    => true,
      password => 'frostyfruit5',
    } ->

    rabbitmq_user { 'sensu':
      admin    => true,
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
      install_repo      => true,
      server            => true,
      manage_services   => true,
      manage_user       => true,
      rabbitmq_password => 'tangymango5',
      rabbitmq_vhost    => '/sensu',
      api               => true,
      api_user          => 'admin',
      api_password      => 'secret',
      client_address    => $::ipaddress_eth0,
      #plugins           => [
      #  'puppet:///data/sensu/plugins/ntp.rb',
      #]
    }

    sensu::handler { 'default':
      command => 'mail -s \'sensu alert\' ops@example',
    }

    sensu::check { 'check_ntp':
      command     => 'PATH=$PATH:/usr/lib/nagios/plugins check_ntp_time -H pool.ntp.org -w 30 -c 60',
      handlers    => 'default',
      subscribers => 'sensu-test',
      type        => 'metric',
    }

    sensu::check { 'check_flapper':
      command     => "PATH=$PATH:/usr/lib/nagios/plugins check_tcp -H ${::ipaddress_eth0} -p 12345",
      interval    => 5,
      handlers    => 'flapjack',
      standalone  => true,
      type        => 'metric',
    }

    sensu::extension { 'flapjack':
        source  => 'puppet:///modules/sensu/extensions/handlers/flapjack.rb',
        config  => {
          'host' => 'localhost',
          'port' => '6380',
          'db'   => '0',
        }
    }

    # Installs the uchiwa dashboard for sensu
    # 0.0.0.0:3000
    # uchiwa, uchiwa

    package { 'uchiwa':
      ensure => present,
    } ->

    file { '/etc/sensu/uchiwa.json':
      ensure  => present,
      content => '
    {
      "sensu": [
        {
          "name": "Site1",
          "host": "localhost",
          "port": 4567,
          "timeout": 5,
          "user": "admin",
          "pass": "secret"
        }
      ],
      "uchiwa": {
        "host": "0.0.0.0",
        "port": 3000,
        "user": "uchiwa",
        "pass": "uchiwa",
        "interval": 5
      }
    }',
      require => Package['uchiwa'],
      notify  => Service['uchiwa'],
    }

    service { 'uchiwa':
      ensure  => running,
      enable  => true,
      require => [ File['/etc/sensu/uchiwa.json'],Package['uchiwa'] ]
    }
  }
}
