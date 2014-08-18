
Exec { path => '/usr/bin:/usr/sbin:/bin:/sbin' }

# Make sure package repositories are up to date before main run

node default {
  class {'apt': always_apt_update => true } ->
  class {'icinga': } ->
  class {'nagios': } ->
  class {'flapjack': }

}
