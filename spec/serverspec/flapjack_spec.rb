require 'serverspec_spec_helper'

describe package('flapjack') do
  it { should be_installed }
end

describe service('flapjack'), :if => os[:family] == 'ubuntu' do
  it { should be_enabled   }
  it { should be_running   }
end

describe service('flapjack'), :if => os[:family] == 'redhat' do
  it { should_not be_enabled   }
  it { should_not be_running   }
end

describe process("redis-server"), :if => os[:family] == 'ubuntu' do
  it { should be_running }
  its(:args) { should match /0.0.0.0:6380/ }
end

describe process("redis-server"), :if => os[:family] == 'redhat' do
  it { should_not be_running }
end

describe process("flapjack"), :if => os[:family] == 'ubuntu' do
  it { should be_running }
  its(:args) { should match   /\/opt\/flapjack\/bin\/flapjack server start/ }
end

describe process("flapjack"), :if => os[:family] == 'redhat' do
  it { should_not be_running }
end

describe port(3080), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe port(3081), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe port(6380), :if => os[:family] == 'ubuntu' do
  it { should be_listening }
end

describe port(3080), :if => os[:family] == 'redhat' do
  it { should_not be_listening }
end

describe port(3081), :if => os[:family] == 'redhat' do
  it { should_not be_listening }
end

describe port(6380), :if => os[:family] == 'redhat' do
  it { should_not be_listening }
end

describe command('/opt/flapjack/bin/flapjack receiver httpbroker --help') do
  its(:stderr) { should match /port/ }
  its(:stderr) { should match /server/ }
  its(:stderr) { should match /database/ }
  its(:stderr) { should match /interval/ }
end

describe file('/etc/flapjack/flapjack_config.yaml') do
  it { should be_file }
  its(:content) { should match /pagerduty/ }
end

describe file('/usr/local/lib/flapjackfeeder.o') do
  it { should be_file }
end

describe file('/var/log/flapjack/flapjack.log') do
  it { should be_file }
end

describe file('/var/log/flapjack/notification.log') do
  it { should be_file }
end
