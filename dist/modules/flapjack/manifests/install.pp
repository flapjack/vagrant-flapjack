class flapjack::install {
  if $operatingsystem in [ 'Ubuntu', 'Debian' ] {
    class{'flapjack::apt': }
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    class{'flapjack::rpm': }
  }
  else {
    fail 'Everything else unsupported'
  }

  package { 'flapjack':
    ensure => present,
    before => Service['flapjack']
  }

  service { 'flapjack':
    ensure  => running,
  }
}
