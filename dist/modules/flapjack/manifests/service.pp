class flapjack::service {

  service { 'flapjack':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => false,
    require    => [
      File['/etc/flapjack/flapjack-config.yaml'],
    ],
    subscribe  => [
      Package['flapjack'],
      File['/etc/flapjack/flapjack-config.yaml'],
    ]
  }

}
