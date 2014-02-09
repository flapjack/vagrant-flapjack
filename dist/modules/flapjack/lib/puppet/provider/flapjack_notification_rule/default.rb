require File.expand_path("../../flapjack", __FILE__)

Puppet::Type.type(:flapjack_notification_rule).
             provide(:default, :parent => Puppet::Provider::Flapjack) do

  def create
    rule = {
      'id'                 => id,
      'contact_id'         => contact_id,
      'entity_tags'        => entity_tags,
      'entities'           => entities,
      'time_restrictions'  => time_restrictions,
      'warning_media'      => warning_media,
      'critical_media'     => critical_media,
      'warning_blackhole'  => warning_blackhole,
      'critical_blackhole' => critical_blackhole
    }.delete_if { |k, v| !v || v.empty?}

    flapjack.create_notification_rule!(rule)
  end

  def destroy
    flapjack.delete_notification_rule!(id)
  end

  def exists?
    !!notification_rule
  end

  (%w(contact_id entity_tags entities time_restrictions) +
  %w(warning_media critical_media) +
  %w(warning_blackhole critical_blackhole)).each do |k|
    class_eval <<-METHOD
      def #{k}
        resource['#{k}']
      end

      def #{k}=(*args)
      end
    METHOD
  end

  private
  def notification_rule
    flapjack.notification_rule(id)
  end

  def id
    resource['id']
  end
end
