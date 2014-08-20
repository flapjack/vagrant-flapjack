require 'rake'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:serverspec) do |t|
  t.pattern = 'spec/serverspec/*_spec.rb'
end

RSpec::Core::RakeTask.new(:capybara) do |t|
  t.pattern = 'spec/capybara/*_spec.rb'
end

task :default => [ :serverspec, :capybara ]
