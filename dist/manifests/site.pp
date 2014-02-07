Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Make sure package repositories are up to date before main run

node default {

  # Make sure package repositories are up to date before main run
  #
  Apt::Source <| |> -> Package <| |>

  # FIXME: this is a dirty hack and should go away as soon as possible.
  # The fix would be to sign the flapjack package propperly.
  # For now, it's OK to install unsigned packages.
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
    sms_media   => {
      address          => '+61412345678',
      interval         => '3600',
      rollup_threshold => '5',
    },
    email_media => {
      address          => 'ada@example.com',
      interval         => '7200',
    }
  }
}
