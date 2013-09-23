class flapjack::config {
  file { '/etc/flapjack/flapjack-config.yaml':
    source  => 'puppet:///modules/flapjack/etc/flapjack/flapjack-config.yaml',
  }
}
