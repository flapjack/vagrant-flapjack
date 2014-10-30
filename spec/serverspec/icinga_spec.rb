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
  its(:content) { should match /broker_module=\/usr\/local\/lib\/flapjackfeeder.o redis_host=localhost,redis_port=6380/ }
end

# Test for named pipes, as there's no be_pipe in rspec
describe command('test -p /var/lib/icinga/rw/icinga.cmd') do
  its(:exit_status) { should eq 0 }
end

describe file('/var/log/icinga/icinga.log') do
  it { should be_file }
end
