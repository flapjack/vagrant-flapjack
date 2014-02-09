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

  def sms_media
    media && media['sms']
  end

  def sms_media=(attrs)
    medium = new_media("sms").merge(attrs)
    flapjack.update_contact_medium!(id, 'sms', medium)
  end

  def email_media
    media && media['email']
  end

  def email_media=(attrs)
    medium = new_media("sms").merge(attrs)
    flapjack.update_contact_medium!(id, 'email', medium)
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
