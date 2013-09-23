# ensure redis is installed, configured and running
# FIXME: this seems to conflict with redis, redis::config, redis::service
class redis::server ( $dump_frequencies = [900, 300, 60] ) {
  include monit

  package { 'redis-server':
    ensure  => latest,
  }

  service { 'redis-server':
    ensure    => running,
    enable    => true,
    hasstatus => false,
    require   => [
      Package['redis-server'],
    ],
  }

  file { '/etc/redis/redis.conf':
    content => template('redis/redis.conf.erb'),
    mode    => '0644',
    owner   => root,
    group   => root,
    require => [
      Package['redis-server']
    ],
    notify  => [
      Service['monit']
    ],
    before  => [
      Service['monit']
    ],
  }

  file { '/etc/monit/conf.d/redis':
    source  => 'puppet:///modules/redis/redis.monit',
    mode    => '0700',
    owner   => root,
    group   => root,
    notify  => [
      Service['monit']
    ],
    require => [
      File['/etc/redis/redis.conf'],
      Package['monit'],
    ],
    before  => [
      Service['monit']
    ],
  }

  file {'/etc/logrotate.d/redis-server':
    ensure  => present,
    source  => 'puppet:///modules/redis/redis.logrotate',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    tag     => 'logrotate',
    require => [
      File['/etc/redis/redis.conf']
    ],
  }

}
