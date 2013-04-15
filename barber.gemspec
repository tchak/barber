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

  gem.add_dependency "execjs"
  gem.add_dependency "handlebars-source", [">= 1.0.0.rc.3"]
  gem.add_dependency "ember-source"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "mocha"
  gem.add_development_dependency "appraisal"
end
