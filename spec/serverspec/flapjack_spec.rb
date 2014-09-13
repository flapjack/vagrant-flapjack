require 'serverspec_spec_helper'

describe package('flapjack') do
  it { should be_installed }
end

describe service('flapjack') do
  it { should be_enabled   }
  it { should be_running   }
end

describe process("redis-server") do
  it { should be_running }
  its(:args) { should match /127.0.0.1:6380/ }
end

describe process("flapjack") do
  it { should be_running }
  its(:args) { should match   /\/opt\/flapjack\/bin\/flapjack server start/ }
end

describe command('test -p /var/lib/nagios3/rw/nagios.cmd') do
  it { should return_exit_status 0 }
end

describe port(80) do
  it { should be_listening }
end
describe port(3080) do
  it { should be_listening }
end
describe port(3081) do
  it { should be_listening }
end
describe port(6380) do
  it { should be_listening }
end

describe command('/opt/flapjack/bin/flapjack receiver httpbroker --help') do
  it { should return_stderr /port/ }
  it { should return_stderr /server/ }
  it { should return_stderr /database/ }
  it { should return_stderr /interval/ }
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
