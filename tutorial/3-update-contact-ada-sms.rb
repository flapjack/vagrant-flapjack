#!/usr/bin/env ruby

# Set the sms_twilio address of Ada to the first argument

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
ada_id = '8d5fd668-b4c4-481b-84be-9db4e5910110'

# Ensure Ada has the correct cell number on her sms_twilio media

medium = {
  :type => 'sms_twilio',
  :address => ada_cell,
  :interval => 1,
  :rollup_threshold => 3
}

ada = Flapjack::Diner.contacts.first

binding.pry

sms_twilios = ada[:links][:media].select {|media_id|
  Flapjack::Diner.media(media_id).first[:type] == 'sms_twilio'
}

case sms_twilios.length
when 0
  puts "==> Creating Ada's sms_twilio media"
  Flapjack::Diner.create_contact_media(ada_id, [medium])
when 1
  existing_media_id = sms_twilios.first
  existing_media = Flapjack::Diner.media(existing_media_id).first
  if existing_media[:address] == ada_cell
    puts "==> Existing address for Ada's sms_twilio is correct"
  else
    puts "==> Updating Ada's sms_twilio address to #{ada_cell}"
    Flapjack::Diner.update_media(existing_media_id, :address => ada_cell)
  end
else
  puts "==> Oh dear, more than 1 sms_twilio media was found for Ada... head aspload"
  exit 1
end

ada = Flapjack::Diner.contacts(ada_id).first

binding.pry

