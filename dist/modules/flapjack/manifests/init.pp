class flapjack {

  class{'flapjack::apt': } ->
  class{'flapjack::install': } ->
  class{'flapjack::config': } ~>
  class{'flapjack::service': } ->
  Class['flapjack']
}
