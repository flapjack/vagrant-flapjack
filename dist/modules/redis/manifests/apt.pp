class redis::apt {

  apt::key { 'redis':
    key        => '5862E31D',
    key_server => 'pgp.mit.edu',
  }
  apt::source { 'launchpad_rwky_redis':
    location => 'http://ppa.launchpad.net/rwky/redis/ubuntu',
    release  => $::lsbdistcodename,
    repos    => 'main',
    key      => '5862E31D',
  }

}
