
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
}
