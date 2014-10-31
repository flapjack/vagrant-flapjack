class flapjack::install {
  if $operatingsystem == 'Ubuntu' {
    class{'flapjack::apt': }
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    class{'flapjack::rpm': }
  }
  else {
    fail 'Everything else unsupported'
  }

  package { 'flapjack':
    ensure => present
  }

  service { 'flapjack':
    ensure  => running,
  }
}
