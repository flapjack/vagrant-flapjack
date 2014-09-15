#!/usr/bin/env ruby 

require 'pry'
require 'httparty'
require 'json'

# Spawn the httpbroker in the background
httpbroker = "flapjack receiver httpbroker --interval=1s"
pid = Process.spawn(httpbroker, [:out,:err] => '/dev/null')
at_exit do
  Process.kill(15, pid)
end

puts "==> Started the httpbroker with pid #{pid}"

# Wait for the httpbroker to start
sleep 2 

# Build up a state, submit it to the httpbroker
state = { :entity => "foo-app-01", :check => "Maple Syrup", :state => "ok", :summary => "Everything is delicious", :ttl => 15 }
response = HTTParty.post("http://localhost:3090/state", :body => state.to_json)

binding.pry
