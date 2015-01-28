require 'serverspec_spec_helper'

context('uchiwa') do
  describe package('uchiwa') do
    it { should be_installed }
  end

  describe process("uchiwa") do
    it { should be_running }
    its(:args) { should match '-c /etc/sensu/uchiwa.json -p /opt/uchiwa/src/public' }
  end

  describe port(4567) do
    it { should be_listening }
  end
end

context('rabbitmq') do
  describe package('rabbitmq-server') do
    it { should be_installed }
  end

  describe process("rabbitmq-server") do
    it { should be_running }
  end

  describe port(15672) do
    it { should be_listening }
  end
end

context('sensu') do
  describe process("sensu-client") do
    it { should be_running }
    its(:args) { should match '-b -c /etc/sensu/config.json -d /etc/sensu/conf.d -e /etc/sensu/extensions -p /var/run/sensu/sensu-client.pid -l /var/log/sensu/sensu-client.log -L info' }
  end

  describe process("sensu-server") do
    it { should be_running }
    its(:args) { should match '-b -c /etc/sensu/config.json -d /etc/sensu/conf.d -e /etc/sensu/extensions -p /var/run/sensu/sensu-server.pid -l /var/log/sensu/sensu-server.log -L info' }
  end

  describe process("sensu-api") do
    it { should be_running }
    its(:args) { should match '-b -c /etc/sensu/config.json -d /etc/sensu/conf.d -e /etc/sensu/extensions -p /var/run/sensu/sensu-api.pid -l /var/log/sensu/sensu-api.log -L info' }
  end
end

# We can't use describe process here, as redis-server matches the flapjack redis as well, and describe process only returns the first result
describe command('ps ax | grep /usr/bin/redis-server') do
  its(:stdout) { should match '/usr/bin/redis-server 0.0.0.0:6379' }
end

describe command("wget -O - 'http://localhost:3080/check?entity=flapjack.example.org&check=check_flapper'") do
  its(:stdout) { should match 'Automatically created for new check' }
  its(:stdout) { should match 'In Scheduled Maintenance' }
  its(:stdout) { should match 'about a minute ago' }
end
