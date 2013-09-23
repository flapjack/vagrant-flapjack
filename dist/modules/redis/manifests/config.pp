# redis::config
# redis config files sorted out here
#
class redis::config {
  file {'/etc/redis/redis.conf':
    content => template('redis/redis.conf.erb'),
    mode   => '0644',
    owner  => root,
    group  => root,
  }
}
