# nginx config template for flapjack web and api
define flapjack::nginx($application_servers, $short_name = $name, $server_name = $fqdn) {

  include nginx::common

  file { "${fqdn}-${short_name}":
    path    => "/etc/nginx/sites-available/${short_name}",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('flapjack/etc/nginx/sites-available/flapjack.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  file { "/etc/nginx/sites-enabled/${short_name}":
    ensure  => link,
    target  => "/etc/nginx/sites-available/${short_name}",
    require => [ File["/etc/nginx/sites-available/${short_name}"] ],
    notify  => [ Service['nginx'] ],
  }

}
