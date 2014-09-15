#!/usr/bin/env ruby

# Set up a contact, Ada, with a mobile number supplied in the first argument for SMS's to be
# delivered via Twilio. Add Ada to the ALL entity.
#
# Refer http://flapjack.io/docs/1.0/usage/Howto-Dynamic-Entity-Contact-Linking/ for further
# information on the behavior of the ALL entity.

require 'flapjack-diner'
require 'pry'
require 'logger'

logdir = 'logs'

# Configure Flapjack::Diner to talk to Flapjack's jsonapi
Flapjack::Diner.base_uri('127.0.0.1:3081')
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log') if File.directory?(logdir)

if ARGV.size == 0
  puts "Error: A cell must be specified for Ada"
  puts
  puts "Usage: #{$0} <cell number>"
  exit 1
end

ada_cell = ARGV.join('')

# Create the ALL entity if it doesn't already exist

entity_all_data = {
  :id   => 'ALL',
  :name => 'ALL'
}

unless Flapjack::Diner.entities(entity_all_data[:id])
  puts "Creating entity: ALL"
  Flapjack::Diner.create_entities([entity_all_data])
end

# Define Ada

ada_data = {
  :id         => '8d5fd668-b4c4-481b-84be-9db4e5910110',
  :first_name => 'Ada',
  :last_name  => 'Lovelace',
  :email      => 'ada@example'
}

# Ensure Ada exists

unless Flapjack::Diner.contacts(ada_data[:id])
  puts "Creating contact: Ada"
  Flapjack::Diner.create_contacts([ada_data])
end

# Ensure Ada has the correct cell number on her sms_twilio media

medium = {
  :type => 'sms_twilio',
  :address => ada_cell,
  :interval => 1,
  :rollup_threshold => 3
}

ada = Flapjack::Diner.contacts(ada_data[:id]).first

sms_twilios = ada[:links][:media].select {|media_id|
  Flapjack::Diner.media(media_id).first[:type] == 'sms_twilio'
}

case sms_twilios.length
when 0
  puts "Creating Ada's sms_twilio media"
  Flapjack::Diner.create_contact_media(ada_data[:id], [medium])
when 1
  existing_media_id = sms_twilios.first
  existing_media = Flapjack::Diner.media(existing_media_id).first
  if existing_media[:address] == ada_cell
    puts "Existing address for Ada's sms_twilio is correct"
  else
    puts "Updating Ada's sms_twilio address to #{ada_cell}"
    Flapjack::Diner.update_media(existing_media_id, :address => ada_cell)
  end
else
  puts "Oh dear, more than 1 sms_twilio media was found for Ada... head aspload"
  exit 1
end

ada = Flapjack::Diner.contacts(ada_data[:id]).first

# Ensure Ada has the ALL entity

entity_all = Flapjack::Diner.entities(entity_all_data[:id]).first
if entity_all[:links][:contacts].include?(ada_data[:id])
  puts "Ada already has the ALL entity"
else
  puts "Adding Ada to the ALL entity"
  Flapjack::Diner.update_entities(entity_all_data[:id], :add_contact => ada_data[:id])
end

puts "Ada is now set up to receive notifications for all failing checks via sms to '#{ada_cell}'"

puts
command = '
flapjack simulate fail_and_recover \
  --entity foo-app-01.example.com \
  --check "HTTP response-time" \
  --state CRITICAL \
  --time 1
'
puts command
puts

