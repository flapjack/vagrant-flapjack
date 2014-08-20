require 'capybara_spec_helper'

describe  "Contact Management", :type => :feature do
  NAME = {
    :first_name => 'Test',
    :last_name => 'Guy'
  }

  MEDIA = {
    :email     => 'testguy@test.com',
    :jabber    => 'testguy@jabber.org',
    :sms       => '0400000000'
  }

  ENTITY = {
    :name  => 'foo-app-01',
    :check => 'bacon'
  }

  it "Add contact" do
    visit '/edit_contacts'
    click_button 'Add contact'

    fill_in('contact_first_name', :with => NAME[:first_name])
    fill_in('contact_last_name', :with => NAME[:last_name])

    click_button 'Create'

    NAME.values.each { |v| expect(page).to have_content v }
  end

  it "Adds media to contact" do
    visit '/edit_contacts'

    sleep 1
    first('tr.contact_list_item').hover
    first(:css, ".btn.btn-default.contact-media", :visible => false).click

    content = [ 'Email', 'Jabber', 'SMS', 'Address', 'Interval' ]
    content.each { |c| expect(page).to have_content c }

    # Add some test content
    find('#Email-address').set MEDIA[:email]
    find('#Jabber-address').set MEDIA[:jabber]
    find('#SMS-address').set MEDIA[:sms]

    first(:css, ".close", :visible => false).click
  end

  it "Adds entity to contact" do
    visit '/edit_contacts'

    sleep 1
    first('tr.contact_list_item').hover
    first(:css, ".btn.btn-default.contact-entities", :visible => false).click

    find(".select2-offscreen").click
    find(".select2-drop li", text: 'foo-app-01').click

    click_button 'Add Entities'
  end

  it "Checks media and entity were added to contact" do
    visit '/contacts'
    click_link "#{NAME[:first_name]} #{NAME[:last_name]}"

    content = [ 'Email', 'Jabber', 'SMS', 'Address', 'Interval',
      'Contact Media', 'Summary Mode', 'Summary Threshold', 'Notification Rules'
    ]
    NAME.values.each { |v| content.push v }
    ENTITY.values.each { |v| content.push v }
    MEDIA.values.each { |v| content.push v }

    content.each { |c| expect(page).to have_content c }

    visit '/check?entity=foo-app-01&check=bacon'
    NAME.values.each { |c| expect(page).to have_content c }
    MEDIA.keys.each { |k| expect(page).to have_content k.capitalize }
  end

  it "Delete contact" do
    visit '/edit_contacts'

    sleep 1
    first('tr.contact_list_item').hover
    first(:css, ".btn.btn-danger.delete-contact", :visible => false).click

    NAME.values.each { |v| expect(page).not_to have_content v }
  end

end
