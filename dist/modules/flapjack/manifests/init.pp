class flapjack {
  class{'flapjack::install': } ->
  class{'flapjack::flapjackfeeder': } ->
  Class['flapjack']
}
