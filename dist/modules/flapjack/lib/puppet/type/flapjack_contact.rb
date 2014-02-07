Puppet::Type.newtype(:flapjack_contact) do
  @doc = "Manage a Flapjack contact"
  ensurable

  newparam :email do
    isnamevar
  end

  newparam :first_name do
    desc "Contact's first name"
  end

  newparam :last_name do
    desc "Contact's last name"
  end

  newparam :timezone do
    desc "Timezone the contact resides in"
  end

  newproperty :sms_media do
    desc "Hash of details for notifying the contact via SMS"

    def insync?(is)
      return false unless is
      pruned = is.delete_if {|k,v| !should.has_key?(k) }
      should == pruned
    end
  end

  newproperty :email_media do
    desc "Hash of details for notifying the contact via email"

    def insync?(is)
      return false unless is
      pruned = is.delete_if {|k,v| !should.has_key?(k) }
      should == pruned
    end
  end
end
