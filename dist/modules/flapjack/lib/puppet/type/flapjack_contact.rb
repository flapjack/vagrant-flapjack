Puppet::Type.newtype(:flapjack_contact) do
  @doc = "Manage a Flapjack contact"
  ensurable

  newparam :email do
    isnamevar
  end

  newparam :first_name do
  end

  newparam :last_name do
  end

  newparam :base_uri do
  end
end
