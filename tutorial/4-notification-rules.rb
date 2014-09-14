#!/usr/bin/env ruby

# Configure notification rules for Ada such that she only receives
# notifications for checks which match one of the following:
# - tagged with 'http' and 'response-time' and
# - on entities containing '-app-'
#
# NOTE: You need to have the sms_twilio gateway enabled and configured in the flapjack config.
# You also will want to set new_check_scheduled_maintenance_duration to '0 seconds' in the flapjack
# config. Restart flapjack like so to ensure the config changes are applied:
# `sudo service flapjack restart`

require 'flapjack-diner'
require 'pry'
require 'logger'

logdir = 'logs'

# Configure Flapjack::Diner to talk to Flapjack's jsonapi
Flapjack::Diner.base_uri('127.0.0.1:3081')
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log') if File.directory?(logdir)

ada_id = '8d5fd668-b4c4-481b-84be-9db4e5910110'

# Remove all contact media from Ada's general notification rule(s)

ada = Flapjack::Diner.contacts(ada_id).first
adas_rules_ids = ada[:links][:notification_rules]
adas_rules = Flapjack::Diner.notification_rules(*adas_rules_ids)

# find all rules that are not specific to tags or entity names

general_rules = adas_rules.select {|rule|
  rule[:tags].empty? && rule[:regex_tags].empty? && rule[:entities].empty? && rule[:regex_entities].empty?
}
binding.pry

# update each rule to remove all contact medias

general_rules.each do |rule|
  Flapjack::Diner.update_notification_rules(rule[:id], :warning_media => [], :critical_media => [], :unknown_media => [])
  updated_rule = Flapjack::Diner.notification_rules(rule[:id])
end

# Create the notification rule that allows http response-time checks on app servers through to
# sms_twilio

specific_rule = {
  :id                 => "10131137-6ae0-4989-a0a0-d00c235b8909",
  :tags               => ['http', 'response-time'],
  :regex_tags         => [],
  :entities           => [],
  :regex_entities     => ['-app-'],
  :time_restrictions  => [],
  :unknown_media      => ['sms_twilio'],
  :warning_media      => ['sms_twilio'],
  :critical_media     => ['sms_twilio'],
  :unknown_blackhole  => false,
  :warning_blackhole  => false,
  :critical_blackhole => false,
  :links              => {:contacts => ada_id}
}

# Delete this specific notification rule if it already exists

if Flapjack::Diner.notification_rules(specific_rule[:id])
  puts "==> deleting specific notification rule (will recreate)"
  Flapjack::Diner.delete_notification_rules(specific_rule[:id])
end

# Create this specific notification rule
Flapjack::Diner.create_contact_notification_rules(ada_id, [specific_rule])
created_rule = Flapjack::Diner.notification_rules(specific_rule[:id])
binding.pry
puts
puts "Lets try it out!"
puts "First, lets simulate a http response-time check for foo-app-01 that should send an SMS to Ada."
puts "Copy and paste this command into your shell:"
command = '
flapjack simulate fail_and_recover \
  --entity foo-app-01.example.com \
  --check "HTTP response-time" \
  --state CRITICAL \
  --time 1
'
puts command
puts
puts "Secondly, lets simulate check that should NOT send an SMS to Ada."
puts "Copy and paste this command into your shell:"
command = '
flapjack simulate fail \
  --entity foo-db-01.example.com \
  --check "Disk Utilisation" \
  --state CRITICAL \
  --time 1
'
puts command

