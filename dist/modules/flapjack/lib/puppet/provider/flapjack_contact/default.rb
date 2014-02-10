require File.expand_path("../../flapjack", __FILE__)

Puppet::Type.type(:flapjack_contact).
             provide(:default, :parent => Puppet::Provider::Flapjack) do

  def create
    # Create the contact
    attrs = {
      'id'         => resource['email'],
      'email'      => resource['email'],
      'first_name' => resource['first_name'],
      'last_name'  => resource['last_name'],
      'timezone'   => resource['timezone']
    }
    flapjack.create_contacts!(attrs)

    # Then create the media associated to the contact
    media = []
    media << new_media('sms').merge(resource['sms_media']) if resource['sms_media']
    media << new_media('email').merge(resource['email_media']) if resource['email_media']

    flapjack.create_media!(media)
  end

  def destroy
    flapjack.delete_contact!(id)
    # FIXME(auxesis): leave the media dangling?
  end

  def exists?
    !!contact
  end

  def first_name
    contact['first_name']
  end

  def first_name=(string)
    attrs = contact(:latest => true).merge({'first_name' => string})
    flapjack.update_contact!(id, attrs)
  end

  def last_name
    contact['last_name']
  end

  def last_name=(string)
    attrs = contact(:latest => true).merge({'last_name' => string})

    p attrs
    p flapjack.update_contact!(id, attrs)
  end

  def timezone
    contact['timezone']
  end

  def timezone=(string)
    attrs = contact(:latest => true).merge({'timezone' => string})
    flapjack.update_contact!(id, attrs)
  end

  %w(sms email).each do |medium|
    class_eval <<-METHOD
      def #{medium}_media
        media && media['#{medium}']
      end

      def #{medium}_media=(attrs)
        if #{medium}_media
          # If the medium exists, update it
          #raise NotImplemented, 'updating media not implemented in flapjack-diner'
          medium = new_media('#{medium}').merge(attrs)
          flapjack.update_contact_medium!(id, '#{medium}', medium)
        else
          # Otherwise, create the medium from scratch and associate it with the contact
          media = new_media('#{medium}').merge(resource['#{medium}_media'])
          flapjack.create_media!(media)
        end
      rescue => e
        puts e.class
        puts e.message
        puts e.backtrace
      end
    METHOD
  end

  private
  def media
    flapjack.contact_media(id)
  end

  def contact(opts={})
    latest = opts[:latest]

    if !@contact or latest
      response = flapjack.contact(id)
      @contact = response ? response["contacts"].first : nil
    else
      @contact
    end
  end

  def new_media(type)
    {
      "type"             => type,
      "contact_id"       => id,
      "interval"         => nil,
      "address"          => nil,
      "rollup_threshold" => nil,
    }
  end

  def id
    resource['email']
  end
end

class NotImplemented < Exception ; end
