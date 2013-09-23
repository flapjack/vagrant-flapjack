# == Class:  redis
#
# A module to manage a redis server.
# Can either be managed by monit or native init/upstart.
#
# == Parameters
#
# [*version*]
#   The package version to install.
#   **default** 'present' to install the latest package
#   'version' to install a specific version
#   'absent' to uninstall package
#
# [*enable*]
#   Should the service be enabled during boot time?
#   **default** true
#
# [*start*]
#   Should the service be started by Puppet
#   **default** true
#
class redis
(
  $version       = 'present',
  $enable        = true,
  $start         = true,
)
{
  class{'redis::install': } ->
  class{'redis::logrotate': } ->
  class{'redis::config': } ~>
  class{'redis::service': } ->
  Class['redis']
}
