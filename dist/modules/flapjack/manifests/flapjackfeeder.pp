# puts flapjackfeeder into place
class flapjack::flapjackfeeder {

  # flapjackfeeder
  file { '/usr/local/lib':
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    before  => File['/usr/local/lib/flapjackfeeder.o'],
  }

  file { '/usr/local/lib/flapjackfeeder.o':
    source  => 'puppet:///modules/flapjack/usr/local/lib/flapjackfeeder.o',
    owner   => root,
    group   => root,
    mode    => '0644',
  }

}
