require 'serverspec_spec_helper'

describe package('icinga') do
  it { should be_installed }
end

describe service('icinga') do
  it { should be_enabled   }
  it { should be_running   }
end

describe process("icinga") do
  it { should be_running }
  its(:args) { should match /-d \/etc\/icinga\/icinga.cfg/ }
end

describe file('/etc/icinga/icinga.cfg') do
  it { should be_file }
  its(:content) { should match /enable_notifications=0/ }
  its(:content) { should match /host_perfdata_file=\/var\/cache\/icinga\/event_stream.fifo/ }
  its(:content) { should match /service_perfdata_file=\/var\/cache\/icinga\/event_stream.fifo/ }
end

# Test for named pipes, as there's no be_pipe in rspec
describe command('test -p /var/cache/icinga/event_stream.fifo') do
  it { should return_exit_status 0 }
end

describe command('test -p /var/lib/icinga/rw/icinga.cmd') do
  it { should return_exit_status 0 }
end

describe file('/var/log/icinga/icinga.log') do
  it { should be_file }
end
