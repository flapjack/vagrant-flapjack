# redis::config
# redis config files sorted out here
#
class redis::config {
  file {'/etc/redis/redis.conf':
    source => 'puppet:///modules/redis/redis.conf',
    mode   => '0644',
    owner  => root,
    group  => root,
  }
}
