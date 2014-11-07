require 'capybara_spec_helper'

describe "Test Flapjack before data is added", :type => :feature do
  before :all do
    # Bring up apache if it isn't already to stop failing nagios checks for localhost
    system("vagrant ssh -c 'if ! curl localhost:80; then sudo service httpd start; sudo touch /var/www/html/index.html; sleep 40; fi' > /dev/null")
  end

  after :each do
    links = [ 'Summary', 'Entities', 'Failing Entities', 'Checks', 'Failing Checks', 'Contacts', 'Internal Statistics' ]
    links.each { |l| expect(page).to have_content l }
  end

  it "Check Summary Page" do
    visit '/'

    content = [ 'Flapjack', '0 out of 1 entities have failing checks', 'checks are failing', 'Summary' ]
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

    content = [ 'Checks', '0 failing out of',
      'Entity', 'Check', 'State', 'Summary', 'Last State Change', 'Last Update', 'Last Notification',
      'Load', 'Users', 'HTTP', 'SSH', 'Total Processes',
      'load average', 'users currently logged in', 'DISK OK', 'HTTP OK', 'SSH OK', 'PROCS OK'
    ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Failing Checks" do
    visit '/checks_failing'

    content = [ 'Failing Checks', '0 failing out of',
      'Entity', 'Check', 'State', 'Summary', 'Last State Change', 'Last Update', 'Last Notification'
    ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Contacts" do
    visit '/contacts'
    wait_for_ajax
    content = [ 'Contacts', 'No contacts' ]
    content.each { |c| expect(page).to have_content c }

    expect(page).to have_link 'Edit contacts'
    click_link 'Edit contacts'
    content = [ 'First Name', 'Last Name', 'Actions' ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Internal Statistics"
end
