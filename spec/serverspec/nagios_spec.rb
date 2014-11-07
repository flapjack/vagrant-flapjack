require 'serverspec_spec_helper'

if ['redhat', 'centos'].include?(os[:family])
  binary = 'nagios'
elsif ['debian', 'ubuntu'].include?(os[:family])
  binary = 'nagios3'
end

describe package(binary) do
  it { should be_installed }
end

describe service(binary) do
  it { should be_running   }
end

describe process(binary) do
  it { should be_running }
  its(:args) { should match /-d \/etc\/nagios(3)?\/nagios.cfg/ }
end

describe user('nagios') do
  it { should exist }
  it { should belong_to_group 'nagios' }
end

describe file("/etc/#{binary}/nagios.cfg") do
  it { should be_file }
  its(:content) { should match /enable_notifications=0/ }
  its(:content) { should match /broker_module=\/usr\/local\/lib\/flapjackfeeder.o redis_host=localhost,redis_port=6380/ }
end

describe file("/var/log/#{binary}/nagios.log") do
  it { should be_file }
end
