# redis::logrotate
# makes use of timsharpe's excellent logrotate module
#
class redis::logrotate {
  logrotate::rule {'redis':
    path          => '/var/log/redis/*.log',
    rotate        => 30,
    copytruncate  => true,
    delaycompress => true,
    compress      => true,
    missingok     => true,
    ifempty       => true
  }
}
