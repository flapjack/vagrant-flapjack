Puppet::Type.newtype(:flapjack_notification_rule) do
  @doc = "Manage a Flapjack contact's notification rule"
  ensurable

  newparam :id do
    validate do |value|
      raise ArgumentError, "Sorry, notification rule ids can't contain whitespace" if value =~ /\s/
    end
    isnamevar
  end

  newproperty :contact_id do
    desc "Contact's identifier"
  end

  newproperty :entity_tags, :array_matching => :all do
    desc "Entity tags to match the notification rule on"
  end

  newproperty :entities, :array_matching => :all do
    desc "Explicit entity names to match the notification rule on"
  end

  newproperty :time_restrictions do
    desc "When a notification rule should match an alert"
  end

  newproperty :warning_media, :array_matching => :all do
    desc "Media to send warning notification to"
  end

  newproperty :critical_media, :array_matching => :all do
    desc "Media to send critical notification to"
  end

  newproperty :warning_blackhole do
    desc "If the warning notifications should be dropped"
    newvalues(:true, :false)
  end

  newproperty :critical_blackhole do
    desc "If the critical notifications should be dropped"
    newvalues(:true, :false)
  end

  autorequire(:service) do
    [ 'flapjack' ]
  end

  autorequire(:flapjack_contact) do
    # FIXME(auxesis): actually make this work
    #[ contact_id ]
  end
end
