# manage the redis process/daemon
#
class redis::service {
  $ensure = $redis::start ? { true => running, default => stopped }

  service {'redis-server':
    ensure    => $ensure,
    enable    => $redis::enable,
    hasstatus => false,
  }
}
