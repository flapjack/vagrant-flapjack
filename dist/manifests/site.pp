Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Make sure package repositories are up to date before main run

node default {
  class { 'apt':
     always_apt_update    => true,
     disable_keys         => true,
  }

  # Make sure package repositories are up to date before main run
  Apt::Source <| |> -> Package <| |>

  package { 'curl':
    ensure => present
  } ->

  class {'icinga': } ->
  class {'nagios': } ->
  class {'flapjack': }

}
