$:.push File.expand_path('../../../gems', __FILE__)
require 'bootstrap'
require 'backports/uri'
require 'flapjack-diner'

class Puppet::Provider::Flapjack < Puppet::Provider
  def flapjack
    @_flapjack ||= ::Flapjack::Diner
    @_flapjack.base_uri 'localhost:3081'
    @_flapjack
  end
end
