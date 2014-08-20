require 'capybara_spec_helper'

describe "Test Flapjack before data is added", :type => :feature do
  after :each do
    links = [ 'Summary', 'Entities', 'Failing Entities', 'Checks', 'Failing Checks', 'Contacts', 'Internal Statistics' ]
    links.each { |l| expect(page).to have_content l }
  end

  it "Check Summary Page" do
    visit '/'

    content = [ 'Flapjack', '0 out of 1 entities have failing checks', '0 out of 6 checks are failing', 'Summary' ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check All Entities" do
    visit '/entities_all'

    content = [ 'Entities', '0 failing out of 1' ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Failing Entities" do
    visit '/entities_failing'

    content = [ 'Failing Entities', '0 failing out of', 'No check output has been processed yet']
    content.each { |c| expect(page).to have_content c }
  end

  it "All Checks" do
    visit '/checks_all'

    content = [ 'Checks', '0 failing out of 6',
      'Entity', 'Check', 'State', 'Summary', 'Last State Change', 'Last Update', 'Last Notification',
      'Load', 'Users', 'Disk Space', 'HTTP', 'SSH', 'Total Processes',
      'load average', 'users currently logged in', 'DISK OK', 'HTTP OK', 'SSH OK', 'PROCS OK'
    ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Failing Checks" do
    visit '/checks_failing'

    content = [ 'Failing Checks', '0 failing out of 6',
      'Entity', 'Check', 'State', 'Summary', 'Last State Change', 'Last Update', 'Last Notification'
    ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Contacts" do
    visit '/contacts'

    content = [ 'Contacts', 'No contacts' ]
    content.each { |c| expect(page).to have_content c }

    expect(page).to have_link 'Edit contacts'
    click_link 'Edit contacts'
    content = [ 'First Name', 'Last Name', 'Actions' ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Internal Statistics"
end
