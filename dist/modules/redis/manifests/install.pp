# redis:install
#
# This installs redis-server via package.
#
class redis::install {
  package{'redis-server':
    ensure => $redis::version
  }
}
