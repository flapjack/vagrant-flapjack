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
    ensure => present
  }

  service { [ 'redis-flapjack' ]:
    ensure  => running,
    require => Package['flapjack'],
  }

  service { [ 'flapjack' ]:
    ensure  => running,
    require => [
      Package['flapjack'],
      Service['redis-flapjack']
    ]
  }
}
