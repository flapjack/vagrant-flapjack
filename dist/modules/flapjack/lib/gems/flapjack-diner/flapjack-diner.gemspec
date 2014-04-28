# -*- encoding: utf-8 -*-
require File.expand_path('../lib/flapjack-diner/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ali Graham"]
  gem.email         = ["ali.graham@bulletproof.net"]
  gem.summary       = %q{Access the API of a Flapjack system monitoring server}
  gem.description   = %q{Wraps raw API calls to a Flapjack server API with friendlier ruby methods.}
  gem.homepage      = 'https://github.com/flpjck/flapjack-diner'

  gem.files         = `git ls-files`.split($\) - ['Gemfile.lock']
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "flapjack-diner"
  gem.require_paths = ["lib"]
  gem.version       = Flapjack::Diner::VERSION

  gem.add_dependency('httparty', '>= 0.10')
  gem.add_dependency('json', '>= 1.7.7')

  gem.add_development_dependency('bundler')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec', '>= 2.0.0')
  gem.add_development_dependency('simplecov')
  gem.add_development_dependency('webmock')
end
