Puppet::Type.newtype(:flapjack_contact) do
  @doc = "Manage a Flapjack contact"
  ensurable

  newparam :email do
    isnamevar
  end

  newproperty :first_name do
    desc "Contact's first name"
  end

  newproperty :last_name do
    desc "Contact's last name"
  end

  newproperty :timezone do
    desc "Timezone the contact resides in"
  end

  newproperty :sms_media do
    desc "Hash of details for notifying the contact via SMS"

    def insync?(is)
      return false unless is
      pruned = is.delete_if {|k,v| !should.has_key?(k)}
      pruned = Hash[pruned.map {|k,v| [k, (v ? v.to_s : v)] }]
      should == pruned
    end

    def is_to_s(value)
      value ? value.inspect : ''
    end

    def should_to_s(value)
      value ? value.inspect : ''
    end

    def should
      {
        'address'          => nil,
        'interval'         => nil,
        'rollup_threshold' => nil,
      }.merge(super)
    end
  end

  newproperty :email_media do
    desc "Hash of details for notifying the contact via email"

    def insync?(is)
      return false unless is
      pruned = is.delete_if {|k,v| !should.has_key?(k)}
      pruned = Hash[pruned.map {|k,v| [k, (v ? v.to_s : v)] }]
      should == pruned
    end

    def is_to_s(value)
      value ? value.inspect : ''
    end

    def should_to_s(value)
      value ? value.inspect : ''
    end
  end

  autorequire(:service) do
    [ 'flapjack' ]
  end
end
