
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Make sure package repositories are up to date before main run

node default {
  class { 'apt':
     always_apt_update => false,
  }

  # Make sure package repositories are up to date before main run
  Apt::Source <| |> -> Package <| |>

  package { 'curl':
    ensure => present
  } ->

  class {'icinga': } ->
  class {'nagios': } ->
  class {'flapjack': } ->

  # FIXME: this is unlikely to work for trusty
  package { 'ruby1.9.1-full':
    ensure => present
  } ->

  package { 'make':
    ensure => present
  } ->

  exec { 'gem install flapjack-diner':
    path   => "/usr/bin:/usr/sbin:/bin",
    unless => "gem list --local | grep flapjack-diner"
  } ->

  exec { 'gem install pry':
    path   => "/usr/bin:/usr/sbin:/bin",
    unless => "gem list --local | grep pry"
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
