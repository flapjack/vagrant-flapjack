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
  class {'redis': } ->
  class {'flapjack': }

}
