# -*- encoding: utf-8 -*-
require File.expand_path('../lib/barber/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["tchak", "twinturbo"]
  gem.email         = ["paul@chavard.net", "me@boardcastingadam.com"]
  gem.description   = %q{Handlebars precompilation}
  gem.summary       = %q{Handlebars precompilation toolkit}
  gem.homepage      = "https://github.com/tchak/barber"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "barber"
  gem.require_paths = ["lib"]
  gem.version       = Barber::VERSION

  gem.add_dependency "execjs", [">= 1.2", "< 3"]
  gem.add_dependency "ember-source", [">= 1.0", "< 3"]

  gem.add_development_dependency "rake"
  gem.add_development_dependency "handlebars-source", "< 4.1"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "mocha", "~> 1.0"
  gem.add_development_dependency "minitest", "~> 5.0"
end
