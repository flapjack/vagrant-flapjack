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
      }
    ]

    flapjack.create_contacts!(contacts)
  end

  def destroy
    id = resource['email']
    flapjack.delete_contact!(id)
  end

  def exists?
    flapjack.contact(resource['email'])
  end
end
