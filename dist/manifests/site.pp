Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Make sure package repositories are up to date before main run

node default {

  # Make sure package repositories are up to date before main run
  #
  Apt::Source <| |> -> Package <| |>

  class {'utils':} ->
  class {'stdlib': } ->
  class {'ruby::common': } ->
  class {'git': } ->
  ruby::version {'1.9.3-p125':
    is_default => true
  } ->

  class {'redis': } ->
  class {'flapjack::coordinator': } ->
  class {'flapjack::nagios_receiver': } ->
  class {'flapjack::flapper': }

}
