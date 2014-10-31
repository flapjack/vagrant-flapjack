require 'serverspec_spec_helper'

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
  its(:content) { should match /broker_module=\/usr\/local\/lib\/flapjackfeeder.o redis_host=localhost,redis_port=6380/ }
end

describe file('/usr/local/lib/flapjackfeeder.o') do
  it { should be_file }
end

# Test for named pipes, as there's no be_pipe in rspec
describe command('test -p /var/lib/nagios3/rw/nagios.cmd') do
  its(:exit_status) { should eq 0 }
end

describe file('/var/log/nagios3/nagios.log') do
  it { should be_file }
end
