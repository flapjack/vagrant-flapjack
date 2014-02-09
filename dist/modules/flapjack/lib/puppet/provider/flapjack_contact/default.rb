require File.expand_path("../../flapjack", __FILE__)

Puppet::Type.type(:flapjack_contact).
             provide(:default, :parent => Puppet::Provider::Flapjack) do

  def create
    contacts = [
      {
        # FIXME(auxesis): Add contact media
        'id'         => resource['email'],
        'email'      => resource['email'],
        'first_name' => resource['first_name'],
        'last_name'  => resource['last_name'],
        'timezone'   => resource['timezone']
      }
    ]

    flapjack.create_contacts!(contacts)
  end

  def destroy
    flapjack.delete_contact!(id)
  end

  def exists?
    contact
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
    if media && media['sms']
      flapjack.update_contact_medium!(id, 'sms', attrs)
    else
      media = {
        "type"       => "sms",
        "contact_id" => id
      }.merge(attrs)

      flapjack.create_media!(media)
    end
  end

  def email_media
    media && media['email']
  end

  def email_media=(attrs)
    if media && media['email']
      flapjack.update_contact_medium!(id, 'email', attrs)
    else
      media = {
        "type"       => "email",
        "contact_id" => id
      }.merge(attrs)

      flapjack.create_media!(media)
    end
  end

  private
  def media
    flapjack.contact_media(id)
  end

  def contact(opts={})
    latest = opts[:latest]

    if !@contact or latest
      @contact = flapjack.contact(id)["contacts"].first
    else
      @contact
    end
  end

  def id
    resource['email']
  end
end
