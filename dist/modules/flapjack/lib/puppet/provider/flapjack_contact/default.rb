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
    contact = flapjack.contact(id)
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

  def id
    resource['email']
  end
end
