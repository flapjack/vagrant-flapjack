require 'serverspec_spec_helper'

describe process("redis-server") do
  it { should be_running }
  its(:args) { should match /0.0.0.0:6380/ }
end

describe process("mailcatcher") do
  it { should be_running }
  its(:args) { should match '--ip 0.0.0.0' }
end

describe port(1080) do
  it { should be_listening }
end
