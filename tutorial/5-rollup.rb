#!/usr/bin/env ruby

require 'pry'
require 'httparty'
require 'json'

# Spawn the simulate fail_and_recover in the background
simulate = "flapjack simulate fail_and_recover --entity foo-app-01.example.com --check 'HTTP response-time' --state CRITICAL --time 2"
pid = Process.spawn(simulate, [:out,:err] => '/dev/null')
at_exit do
  Process.kill(15, pid)
end

puts "==> Spawned simulate fail_and_recover with pid #{pid}"
puts "==> You should see 1 problem alert in ~40 seconds"

# Wait a little bit for the initial problem alert to go out
puts "==> Waiting 30 seconds before simulating more failing checks"
sleep 30

# Start more failing checks. The summary threshold should kick in.
(2..5).each do |i|
  simulate = "flapjack simulate fail_and_recover --entity foo-app-0#{i}.example.com --check 'HTTP response-time' --state CRITICAL --time 1"
  pid = Process.spawn(simulate, [:out,:err] => '/dev/null')
  at_exit do
    Process.kill(15, pid)
  end
  puts "==> Spawned simulate fail_and_recover with pid #{pid}"
end
puts "==> You should see 1 summary alert in ~40 seconds"

puts "==> Waiting 80 seconds for recoveries to kick in"
sleep 80
