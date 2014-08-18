class flapjack::apt {
  apt::source { 'flapjack':
    location    => "http://packages.flapjack.io/deb/${flapjack_major_version}",
    release     => $release,
    repos       => $component,
    key         => '803709B6',
    include_src => false,
  }
}
