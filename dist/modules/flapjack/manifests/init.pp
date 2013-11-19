class flapjack {

  class{'flapjack::apt': } ->
  class{'flapjack::install': } ->
  #class{'flapjack::config': } ~>
  #class{'flapjack::service': } ->
  class{'flapjack::flapjackfeeder': } ->
  Class['flapjack']
}
