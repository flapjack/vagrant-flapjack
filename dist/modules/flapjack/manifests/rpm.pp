class flapjack::rpm {
  $os = downcase($operatingsystem)
  yumrepo { 'flapjack':
    ensure => present,
    baseurl => "http://packages.flapjack.io/rpmtest/${flapjack_major_version}/${flapjack_component}/${os}/${operatingsystemmajrelease}/${architecture}",
    enabled => 'Yes',
    gpgcheck => 'No'
  }

  Yumrepo <| |> -> Package <| |>

  # Stop the firewall on rpm machines to make vagrant forwarded ports work
  service { 'iptables':
    ensure  => stopped
  }
}
