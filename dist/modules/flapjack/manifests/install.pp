class flapjack::install {
  if $operatingsystem == 'Ubuntu' {
    class{'flapjack::apt': }

    package { 'flapjack':
      ensure => present
    }
  }
  elsif $operatingsystem in [ 'CentOS', 'RedHat' ] {
    class{'flapjack::rpm': }

    exec { 'curl http://packages.flapjack.io/rpm/flapjack-1.2.0~rc2~20141017115520_v1.2.0rc2_6-1.el6.x86_64.rpm':
      path   => "/usr/bin:/usr/sbin:/bin",
    } ->

    exec { 'yum --nogpgcheck localinstall flapjack-1.2.0~rc2~20141017115520_v1.2.0rc2_6-1.el6.x86_64.rpm':
      path   => "/usr/bin:/usr/sbin:/bin",
    }
  }
  else {
    fail 'Everything else unsupported'
  }
}
