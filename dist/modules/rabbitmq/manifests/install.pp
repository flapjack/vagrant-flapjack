# Class rabbitmq::install
# Ensures the rabbitmq-server exists
class rabbitmq::install {

  $package_ensure   = $rabbitmq::package_ensure
  $package_name     = $rabbitmq::package_name
  $package_provider = $rabbitmq::package_provider
  $package_source   = $rabbitmq::real_package_source

  # Erlang is required on rpm-based systems, and isn't automatically installed as a dependency
  if $operatingsystem in [ 'CentOS', 'RedHat' ] {
    package { 'erlang':
      ensure => present,
      before => Package['rabbitmq-server'],
    }
  }

  package { 'rabbitmq-server':
    ensure   => $package_ensure,
    name     => $package_name,
    provider => $package_provider,
    notify   => Class['rabbitmq::service'],
  }

  if $package_source {
    Package['rabbitmq-server'] {
      source  => $package_source,
    }
  }

}
