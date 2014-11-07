class flapjack::apt {
  apt::source { 'flapjack':
    location    => "http://packages.flapjack.io/deb/${flapjack_major_version}",
    release     => $lsbdistcodename,
    repos       => $flapjack_component,
    key         => '803709B6',
    include_src => false,
  }

  Apt::Source <| |> -> Package <| |>
}
