require 'spec_helper'

describe package('nagios3') do
  it { should be_installed }
end

describe service('nagios3') do
  it { should be_enabled   }
  it { should be_running   }
end

describe process("nagios3") do
  it { should be_running }
  its(:args) { should match /-d \/etc\/nagios3\/nagios.cfg/ }
end

describe user('nagios') do
  it { should exist }
  it { should belong_to_group 'nagios' }
end

describe file('/etc/nagios3/nagios.cfg') do
  it { should be_file }
  its(:content) { should match /enable_notifications=0/ }
  its(:content) { should match /host_perfdata_file=\/var\/cache\/icinga\/event_stream.fifo/ }
  its(:content) { should match /service_perfdata_file=\/var\/cache\/icinga\/event_stream.fifo/ }
end

# Test for named pipes, as there's no be_pipe in rspec
describe command('test -p /var/cache/icinga/event_stream.fifo') do
  it { should return_exit_status 0 }
end

describe command('test -p /var/lib/nagios3/rw/nagios.cmd') do
  it { should return_exit_status 0 }
end

describe file('/var/log/nagios3/nagios.log') do
  it { should be_file }
end
