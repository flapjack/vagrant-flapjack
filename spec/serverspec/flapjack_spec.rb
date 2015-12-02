require 'serverspec_spec_helper'

def flapjack_major_version
  return @flapjack_major_version unless @flapjack_major_version.nil?
  @flapjack_major_version = ENV['flapjack_major_version'] || '-1'
  @flapjack_major_version
end

describe service('redis-flapjack'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  it { should be_enabled }
end
describe service('redis-flapjack'), :if => 'redhat'.eql?(os[:family]) do
  it { should_not be_enabled }
end

describe service('flapjack'), :if => ['debian', 'ubuntu'].include?(os[:family]) do
  it { should be_enabled }
end
describe service('flapjack'), :if => 'redhat'.eql?(os[:family]) do
  it { should_not be_enabled }
end

describe package('flapjack') do
  it { should be_installed }
end

describe service('flapjack') do
  it { should be_running }
end

describe process("redis-server") do
  it { should be_running }
  its(:args) { should match /0.0.0.0:6380/ }
end

describe process("flapjack"), :if => ['0', '1'].include?(flapjack_major_version) do
  it { should be_running }
  its(:args) { should match %r{/opt/flapjack/bin/flapjack server start} }
end

describe process("flapjack"), :if => '2'.eql?(flapjack_major_version) do
  it { should be_running }
  its(:args) { should match %r{/opt/flapjack/bin/flapjack server} }
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

describe command('/opt/flapjack/bin/flapjack receiver httpbroker --help'), :unless => '0'.eql?(flapjack_major_version) do
  its(:stdout) { should match /port/ }
  its(:stdout) { should match /server/ }
  its(:stdout) { should match /database/ }
  its(:stdout) { should match /interval/ }
end

describe file("/etc/flapjack/flapjack_config.#{['0', '1'].include?(flapjack_major_version) ? 'yaml' : 'toml'}") do
  it { should be_file }
  its(:content) { should match /pagerduty/ }
end

describe file('/usr/local/lib/flapjackfeeder.o') do
  it { should be_file }
end

if ['0', '1'].include?(flapjack_major_version)
  describe file('/var/log/flapjack/flapjack.log') do
    it { should be_file }
    it { should be_mode 644 }
  end

  describe file('/var/log/flapjack/notification.log') do
    it { should be_file }
    it { should be_mode 644 }
  end
end

describe file('/var/log/flapjack/jsonapi_access.log') do
  it { should be_file }
  it { should be_mode 644 }
end

describe file('/var/log/flapjack/redis-flapjack.log') do
  it { should be_file }
  it { should be_mode 644 }
end

describe file('/var/log/flapjack/web_access.log') do
  it { should be_file }
  it { should be_mode 644 }
end
