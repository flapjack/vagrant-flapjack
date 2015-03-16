class mailcatcher {
  case $operatingsystem {
    'RedHat', 'CentOS': {
      package { 'centos-release-SCL':
        ensure => present
      } ->

      exec { "yum groupinstall -y 'Development Tools'":
      } ->

      package { [ 'ruby193', 'ruby193-ruby-devel' ]:
        ensure => present
      }
    }
    'Ubuntu', 'Debian': {
      package { [ 'ruby1.9.1-full', 'build-essential', 'libsqlite3-dev' ]:
        ensure => present
      }
    }
    default: {
      fail('Unsupported operating system')
    }
  }

  package { 'make':
    ensure => present
  } ->

  exec { 'if [[ -f /opt/rh/ruby193/enable ]]; then echo "export PATH=\${PATH}:/opt/rh/ruby193/root/usr/local/bin" | tee -a /opt/rh/ruby193/enable && source /opt/rh/ruby193/enable; fi && gem install mailcatcher':
    path     => "/usr/bin:/usr/sbin:/bin:/opt/rh/ruby193/root/usr/local/bin",
    provider => "shell",
    unless   => "gem list --local | grep mailcatcher",
    before   => Exec['mailcatcher']
  }

  exec { 'mailcatcher':
    command  => 'if [[ -f /opt/rh/ruby193/enable ]]; then source /opt/rh/ruby193/enable; fi && mailcatcher --ip 0.0.0.0',
    provider => "shell",
    unless   => "pgrep mailcatcher",
    path     => '/usr/local/bin:/usr/bin:/opt/rh/ruby193/root/usr/local/bin'
  }

  exec { 'enable-mailcatcher-in-flapjack':
    command => 'perl -0777 -i.original -pe \'s/email:(\s+)enabled: no/email:\1enabled: yes/igs\' /etc/flapjack/flapjack_config.yaml; perl -0777 -i.original -pe \'s/(.*)# from: "Flapjack Example/\1from: "Flapjack Example/igs\' /etc/flapjack/flapjack_config.yaml',
    notify  => Service['flapjack']
  }
}
