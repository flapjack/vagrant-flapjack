class flapjack {

  class{'flapjack::apt': } ->
  class{'flapjack::install': } ->
  class{'flapjack::flapjackfeeder': } ->
  Class['flapjack']
}
