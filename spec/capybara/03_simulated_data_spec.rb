require 'capybara_spec_helper'

describe "Simulate a failed check", :type => :feature do
  before :all do
    # vagrant ssh -c 'sudo /opt/flapjack/bin/flapjack simulate fail --check bacon'
    BACON_URI = '/check?entity=foo-app-01&check=bacon'
  end

  it "Check Failing Entities" do
    visit '/entities_failing'

    content = [ 'Failing Entities', '1 failing out of', 'foo-app-01' ]
    content.each do |c|
      expect(page).to have_content c
    end
  end

  it "Check Failing Checks" do
    visit '/checks_failing'

    content = [ 'Failing Checks', '1 failing out of', 'foo-app-01', 'bacon',
      'Entity', 'Check', 'State', 'Summary', 'Last State Change', 'Last Update', 'Last Notification'
    ]
    content.each do |c|
      expect(page).to have_content c
    end
  end

  it "Loads failing check" do
    visit BACON_URI

    content = [ 'foo-app-01', 'bacon', 'CRITICAL',
      'Last state change', 'Summary', 'State', 'Reason', 'Started', 'Finishing', 'Remaining',
      'Scheduled Maintenance Periods', 'Add Scheduled Maintenance', 'Contacts', 'Decommission Check'
    ]
    content.each do |c|
      expect(page).to have_content c
    end
  end

it "Use scheduled Maintenance" do
  visit BACON_URI

end

it "Use unscheduled Maintenance" do
  visit BACON_URI

end

  it "Decommission check" do
    visit BACON_URI

    click_button 'Decommission Check'

    content = [ 'This check has been decommissioned', 'DISABLED' ]
    content.each do |c|
      expect(page).to have_content c
    end
  end

end
# after :all do # Clear redis
#   vagrant ssh -c 'sudo /opt/flapjack/bin/flapjack simulate fail --check bacon'
# end
