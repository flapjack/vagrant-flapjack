require 'capybara_spec_helper'

describe "Simulate a failed check", :type => :feature do
  before :all do
    system("vagrant ssh -c 'sudo /opt/flapjack/bin/flapjack simulate fail --check bacon'")
    BACON_URI = '/check?entity=foo-app-01&check=bacon'
  end

  it "Check Failing Entities" do
    visit '/entities_failing'

    content = [ 'Failing Entities', '1 failing out of', 'foo-app-01' ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Check Failing Checks" do
    visit '/checks_failing'

    content = [ 'Failing Checks', '1 failing out of', 'foo-app-01', 'bacon',
      'Entity', 'Check', 'State', 'Summary', 'Last State Change', 'Last Update', 'Last Notification'
    ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Loads failing check" do
    visit BACON_URI

    content = [ 'foo-app-01', 'bacon', 'CRITICAL',
      'Last state change', 'Summary', 'State', 'Reason', 'Started', 'Finishing', 'Remaining',
      'Scheduled Maintenance Periods', 'Add Scheduled Maintenance', 'Contacts', 'Decommission Check'
    ]
    content.each { |c| expect(page).to have_content c }
  end

  it "Ends initial Maintenance" do
    visit BACON_URI

    within(:css, "#scheduled-maintenance") do
      content = [ 'In Scheduled Maintenance', 'Automatically created for new check' ]
      content.each { |c| expect(page).to have_content c }
    end

    # End the maintenance
    click_button 'End Now'
    within(:css, "#no-unscheduled-maintenance") do
      no_content = [ 'In Scheduled Maintenance', 'Automatically created for new check' ]
      no_content.each { |c| expect(page).to_not have_content c }
      content = [ 'Acknowledge alert', 'Summary' ]
      content.each { |c| expect(page).to have_content c }
    end
  end

  it "Adds and removes scheduled maintenance starting now" do
    visit BACON_URI
    MAINTENANCE = {
      :start_time => 'now',
      :duration   => '3 hrs',
      :summary    => 'Off to the lake'
    }

    within(:css, "#scheduled-maintenance-summary") do
      no_content = [ 'In Scheduled Maintenance', 'Automatically created for new check' ]
      no_content.each { |c| expect(page).to_not have_content c }
      content = [ 'Acknowledge alert', 'Summary' ]
      content.each { |c| expect(page).to have_content c }
    end

    # Add more maintenance
    within(:css, "#add-scheduled-maintenance") do
      fill_in('start_time', :with => MAINTENANCE[:start_time])
      fill_in('duration', :with => MAINTENANCE[:duration])
      fill_in('summary', :with => MAINTENANCE[:summary])
      click_button 'Save'
    end

    within(:css, "#scheduled-maintenance-summary") do
      no_content = [ 'Acknowledge alert', 'Summary' ]
      no_content.each { |c| expect(page).to_not have_content c }
      content = [ 'In Scheduled Maintenance', 'Off to the lake' ]
      content.each { |c| expect(page).to have_content c }
    end

    # End the maintenance
    within(:css, "#scheduled-maintenance-periods") do
      click_button 'End Now'
    end

    within(:css, "#scheduled-maintenance-summary") do
      no_content = [ 'In Scheduled Maintenance', 'Automatically created for new check' ]
      no_content.each { |c| expect(page).to_not have_content c }
      content = [ 'Acknowledge alert', 'Summary' ]
      content.each { |c| expect(page).to have_content c }
    end
  end

  it "Adds and removes future scheduled Maintenance" do
    visit BACON_URI
    MAINTENANCE = {
      :start_time => '2023-04-04 16:00:00',
      :duration   => '3 hrs',
      :summary    => 'Off to the park'
    }

    within(:css, "#add-unscheduled-maintenance") do
      no_content = [ 'In Scheduled Maintenance', 'Automatically created for new check' ]
      no_content.each { |c| expect(page).to_not have_content c }
      content = [ 'Acknowledge alert', 'Summary' ]
      content.each { |c| expect(page).to have_content c }
    end

    # Add more maintenance
    within(:css, "#add-scheduled-maintenance") do
      fill_in('start_time', :with => MAINTENANCE[:start_time])
      fill_in('duration', :with => MAINTENANCE[:duration])
      fill_in('summary', :with => MAINTENANCE[:summary])
      click_button 'Save'
    end

    MAINTENANCE.values.each { |v| expect(page).to have_content v }

    within(:css, "#add-unscheduled-maintenance") do
      no_content = [ 'In Scheduled Maintenance', 'Automatically created for new check' ]
      no_content.each { |c| expect(page).to_not have_content c }
      content = [ 'Acknowledge alert', 'Summary' ]
      content.each { |c| expect(page).to have_content c }
    end

    # End the maintenance
    within(:css, "#scheduled-maintenance-periods") do
      click_button 'Delete'
    end
    MAINTENANCE.values.each { |v| expect(page).to_not have_content v }
  end

  it "Use unscheduled Maintenance" do
    visit BACON_URI

    FIRST_MAINTENANCE = {
      :duration   => '2 hrs',
      :summary    => 'Off to the zoo'
    }

    within(:css, "#add-unscheduled-maintenance") do
      fill_in('summary', :with => FIRST_MAINTENANCE[:summary])
      fill_in('duration', :with => FIRST_MAINTENANCE[:duration])
      click_button 'Acknowledge'
    end

    within(:css, "#unscheduled-maintenance-summary") do
      content = [ 'Acknowledged', FIRST_MAINTENANCE[:summary] ]
      content.each { |c| expect(page).to have_content c }
    end

    SECOND_MAINTENANCE = {
      :duration   => '2 hrs',
      :summary    => 'Off to the shops'
    }

    within(:css, "#add-unscheduled-maintenance") do
      fill_in('summary', :with => SECOND_MAINTENANCE[:summary])
      fill_in('duration', :with => SECOND_MAINTENANCE[:duration])
      click_button 'Replace acknowledgment'
    end

    within(:css, "#unscheduled-maintenance-summary") do
      content = [ 'Acknowledged', SECOND_MAINTENANCE[:summary] ]
      content.each { |c| expect(page).to have_content c }
    end

    click_button 'End Unscheduled Maintenance (Unacknowledge)'
    content = [ 'Acknowledged', FIRST_MAINTENANCE[:summary], SECOND_MAINTENANCE[:summary] ]
    content.each { |c| expect(page).to_not have_content c }
  end

  it "Decommission check" do
    visit BACON_URI

    click_button 'Decommission Check'

    content = [ 'This check has been decommissioned', 'DISABLED' ]
    content.each { |c| expect(page).to have_content c }
  end
end
# after :all do # Clear redis
#   vagrant ssh -c 'sudo /opt/flapjack/bin/flapjack simulate fail --check bacon'
# end
