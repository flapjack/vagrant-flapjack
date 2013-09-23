class flapjack::apt {
  apt::source { 'flapjack':
    location    => 'http://packages.flapjack.io/deb',
    repos       => 'main',
    #key         => 'CD2EFD2A',
    include_src => false,
  }
}
