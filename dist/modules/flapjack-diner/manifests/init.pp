class flapjack-diner {
  case $operatingsystem {
    'RedHat', 'CentOS': {
      package { 'centos-release-SCL':
        ensure => present
      } ->
      package { [ 'ruby193', 'ruby193-ruby-devel' ]:
        ensure => present
      }
    }
    'Ubuntu', 'Debian': { package { [ 'ruby1.9.1-full', 'build-essential', 'libsqlite3-dev' ]: ensure => present } }
    default:            { fail('Unsupported operating system') }
  }

  package { 'make':
    ensure => present
  } ->

  exec { 'gem install flapjack-diner':
    path   => "/usr/bin:/usr/sbin:/bin",
    unless => "gem list --local | grep flapjack-diner"
  } ->

  exec { 'gem install pry':
    path   => "/usr/bin:/usr/sbin:/bin",
    unless => "gem list --local | grep pry"
  }
}
