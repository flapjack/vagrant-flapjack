class flapjack-diner {
  exec { 'gem install flapjack-diner':
    path   => "/usr/bin:/usr/sbin:/bin",
    unless => "gem list --local | grep flapjack-diner"
  } ->

  exec { 'gem install pry':
    path   => "/usr/bin:/usr/sbin:/bin",
    unless => "gem list --local | grep pry"
  }
}
