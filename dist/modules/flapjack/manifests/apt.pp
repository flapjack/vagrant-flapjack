class flapjack::apt {
  apt::source { 'flapjack':
    location    => 'http://packages.flapjack.io/deb',
    release     => 'precise',
    repos       => 'main',
    #key         => 'CD2EFD2A',
    include_src => false,
  }
}
