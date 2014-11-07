require 'capybara/rspec'
require 'capybara/poltergeist'

module WaitForAjax
  def wait_for_ajax
    Timeout.timeout(Capybara.default_wait_time) do
      loop until finished_all_ajax_requests?
    end
  end

  def finished_all_ajax_requests?
    page.evaluate_script('jQuery.active').zero?
  end
end

Capybara.configure do |config|
  config.app_host = 'http://localhost:3080'
  config.default_wait_time = 5
end

RSpec.configure do |config|
  config.before :suite do
    if ! ENV['FF'].nil?
      require 'selenium-webdriver'
    else
      require 'capybara/poltergeist'
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
          js_errors: true,
          inspector: true,
          phantomjs_options: ['--load-images=no', '--web-security=false'],
          timeout: 120
        })
      end
    end
    Capybara.default_driver = ENV['FF'] == 'true' ? Capybara.javascript_driver : :poltergeist
  end
  config.include WaitForAjax, type: :feature
end
