#!/usr/bin/env ruby

# Set up pagerduty on ada with flapjack-project test account

require 'flapjack-diner'
require 'pry'
require 'logger'

logdir = 'logs'

# Configure Flapjack::Diner to talk to Flapjack's jsonapi
Flapjack::Diner.base_uri('127.0.0.1:3081')
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log') if File.directory?(logdir)

ada_id = '8d5fd668-b4c4-481b-84be-9db4e5910110'

# Ensure Ada has the pagerduty

pagerduty_creds = {
  :service_key => "4e3de0d942144dd4b88e925f74f844d7",
  :subdomain => "foo-bar",
  :username => "ada@example",
  :password => "password",
}

ada = Flapjack::Diner.contacts(ada_id).first

binding.pry

pagerduty = Flapjack::Diner.pagerduty_credentials(ada_id)

case pagerduty.length
when 0
  puts "==> Creating Ada's pagerduty media"
  result = Flapjack::Diner.create_contact_pagerduty_credentials(ada_id, pagerduty_creds)
  unless result
    puts "damn"
    binding.pry
  end
when 1
  puts "==> Checking existing pagerduty credential"
  binding.pry
  [:service_key, :subdomain, :username, :password].each {|field|
    if pagerduty.first[field] == pagerduty_creds[field]
      puts "#{field} is correct (#{pagerduty_creds[field]})"
    else
      puts "updating #{field} (old: #{pagerduty.first[field]}, new: #{pagerduty_creds[field]})"
      result = Flapjack::Diner.update_pagerduty_credentials(ada_id, field => pagerduty_creds[field])
    end
  }
else
  puts "==> Oh dear, more than 1 pagerduty media was found for Ada... head aspload"
  exit 1
end

ada = Flapjack::Diner.contacts(ada_id).first
binding.pry

