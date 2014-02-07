Puppet::Type.newtype(:flapjack) do
  @doc = "Manage a Flapjack instance"
  ensurable

  newparam :name do
    desc "Flapjack instance name"
    isnamevar
  end

  newparam :base_uri do
  end
end
