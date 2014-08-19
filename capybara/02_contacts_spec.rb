require 'capybara_spec_helper'

describe  "Contact Management", :type => :feature do
  NAME = {
    :first_name => 'Test',
    :last_name => 'Guy'
  }
  MEDIA = {
    :email     => 'testguy@test.com',
    :jabber    => 'testguy@jabber.org',
    :sms      => '0400000000'
  }

  it "Add contact" do
    visit '/edit_contacts'
    click_button 'Add contact'

    fill_in('contact_first_name', :with => NAME[:first_name])
    fill_in('contact_last_name', :with => NAME[:last_name])

    click_button 'Create'

    NAME.each { |k,v| expect(page).to have_content v }
  end

  it "Adds media to contact" do
    visit '/edit_contacts'

    sleep 1
    first('tr.contact_list_item').hover
    first(:css, ".btn.btn-default.contact-media", :visible => false).click

    content = [ 'Media for', 'Email', 'Jabber', 'SMS', 'Address' ]

    # Add some test content
    find('#Email-address').set MEDIA[:email]
    find('#Jabber-address').set MEDIA[:jabber]
    find('#SMS-address').set MEDIA[:sms]

    first(:css, ".close", :visible => false).click

    # Now check it was saved
    visit '/edit_contacts'

    sleep 1
    first('tr.contact_list_item').hover
    first(:css, ".btn.btn-default.contact-media", :visible => false).click

    have_selector("#Email-address", :text => MEDIA[:email])
    have_selector("#Jabber-address", :text => MEDIA[:jabber])
    have_selector("#SMS-address", :text => MEDIA[:sms])
  end

  it "Delete contact" do
    visit '/edit_contacts'

    sleep 1
    first('tr.contact_list_item').hover
    first(:css, ".btn.btn-danger.delete-contact", :visible => false).click

    NAME.each { |k,v| expect(page).not_to have_content v }
  end

end
