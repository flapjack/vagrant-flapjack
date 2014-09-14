#!/usr/bin/env ruby

# Ensure entity ALL exists

require 'flapjack-diner'
require 'pry'
require 'logger'

logdir = 'logs'

# Configure Flapjack::Diner to talk to Flapjack's jsonapi
Flapjack::Diner.base_uri('127.0.0.1:3081')
Flapjack::Diner.logger = Logger.new('logs/flapjack_diner.log') if File.directory?(logdir)

# Create the ALL entity if it doesn't already exist

entity_all_data = {
  :id   => 'ALL',
  :name => 'ALL'
}

puts

unless Flapjack::Diner.entities(entity_all_data[:id])
  puts "==> Creating entity: ALL..."
  Flapjack::Diner.create_entities([entity_all_data])
else
  puts "==> The ALL entity already exists:"
end

# Retrieve the ALL entity for inspection

entity_all = Flapjack::Diner.entities('ALL').first
pp entity_all

binding.pry

