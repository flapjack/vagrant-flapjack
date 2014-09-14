#!/usr/bin/env ruby

# Ensure contact Ada exists
# Ensure contact Ada has the ALL entity
# List all contacts

require 'flapjack-diner'
require 'pry'
require 'logger'

logdir = 'logs'

# Configure Flapjack::Diner to talk to Flapjack's jsonapi
Flapjack::Diner.base_uri('127.0.0.1:3081')
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log') if File.directory?(logdir)

# Define Ada

ada_data = {
  :id         => '8d5fd668-b4c4-481b-84be-9db4e5910110',
  :first_name => 'Ada',
  :last_name  => 'Lovelace',
  :email      => 'ada@example'
}

puts

# Ensure Ada exists

unless Flapjack::Diner.contacts(ada_data[:id])
  puts "==> Creating contact: Ada"
  Flapjack::Diner.create_contacts([ada_data])
end

# Ensure Ada has the ALL entity

entity_all = Flapjack::Diner.entities('ALL').first
if entity_all[:links][:contacts].include?(ada_data[:id])
  puts "==> Ada already has the ALL entity"
else
  puts "==> Adding Ada to the ALL entity"
  Flapjack::Diner.update_entities('ALL', :add_contact => ada_data[:id])
end

ada = Flapjack::Diner.contacts(ada_data[:id])

binding.pry

