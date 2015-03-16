require 'serverspec'
require 'net/ssh'
require 'tempfile'

set :backend, :ssh

# Hardcode the host so that Net::SSH::Config.for(...) finds the right box.
# This should be completely unnecessary.
host = 'flapjack'

puts "Bringing up vagrant for host #{host} if required"
exit_status = system("vagrant up #{host}")
unless exit_status
  puts "Error bringing up vagrant for host #{host}. Exiting!"
  exit 1
end
puts "Done ensuring vagrant is up for host #{host}."

config = Tempfile.new('', Dir.tmpdir)
system("vagrant ssh-config #{host} > #{config.path}")

options = Net::SSH::Config.for(host, [config.path])

options[:user] ||= Etc.getlogin

set :host,        options[:host_name] || host
set :ssh_options, options
