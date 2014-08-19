require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.configure do |config|
  config.app_host = 'http://localhost:3080'
  config.default_wait_time = 5
end

RSpec.configure do |config|
  config.before :suite do
    if ENV['FF'] == 'true' # in case you wanna run it with selenium
      require 'selenium-webdriver'
    else
      require 'capybara/poltergeist'
      Capybara.register_driver :poltergeist do |app|
        Capybara::Poltergeist::Driver.new(app, {
          js_errors: true,
          inspector: true,
          phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes'],
          timeout: 120
        })
      end
    end
    Capybara.default_driver = ENV['FF'] == 'true' ? Capybara.javascript_driver : :poltergeist
  end
end
