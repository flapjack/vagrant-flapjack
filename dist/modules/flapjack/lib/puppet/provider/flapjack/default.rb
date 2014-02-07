require File.expand_path("../../flapjack", __FILE__)

Puppet::Type.type(:flapjack).
             provide(:default, :parent => Puppet::Provider::Flapjack) do

  def create
    raise "not implemented"
  end

  def destroy
    raise "not implemented"
  end

  def exists?
    true
  end
end
