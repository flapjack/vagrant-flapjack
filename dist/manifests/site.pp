Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

#hiera_resources(['resources'])

node default {

  # Make sure package repositories are up to date before main run
  #
  Apt::Source <| |> -> Package <| |>

  File ['/etc/apt/apt.conf.d/99auth']-> Package <| |>
  file { '/etc/apt/apt.conf.d/99auth':
    owner     => root,
    group     => root,
    content   => 'APT::Get::AllowUnauthenticated yes;',
    mode      => '0644',
  }

  package { 'curl':
    ensure => present
  } ->

  class {'icinga': } ->
  class {'nagios': } ->
  class {'flapjack': }

  flapjack_contact { 'ada@example.com':
    ensure      => present,
    first_name  => 'Ada',
    last_name   => 'Lovelace',
    timezone    => 'Europe/London',
#    sms_media   => {
#      address          => '+61412345678',
#      interval         => '120',
#      rollup_threshold => '5',
#    },
#    email_media => {
#      address          => 'ada@example.com',
#      interval         => '1800',
#    }
  }

#  flapjack_notification_rule { 'ada-catchall':
#    contact_id         => 'ada@example.com',
#    warning_media      => [ 'email' ],
#    critical_media     => [ 'sms' ],
#  }
#
#  flapjack_notification_rule { 'ada-app-01':
#    contact_id     => 'ada@example.com',
#    entities       => [ 'app-01.example.com' ],
#    warning_media  => [ 'sms' ],
#    critical_media => [ 'sms' ],
#  }
#
#  flapjack_notification_rule { 'ada-db':
#    contact_id     => 'ada@example.com',
#    entity_tags    => [ 'db' ],
#    warning_media  => [ 'email' ],
#    critical_media => [ ],
#  }

}
