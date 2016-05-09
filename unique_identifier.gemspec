# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'unique_identifier/version'

Gem::Specification.new do |spec|
  spec.name          = "unique_identifier"
  spec.version       = UniqueIdentifier::VERSION
  spec.authors       = ["Justin Grubbs"]
  spec.email         = ["justin@jgrubbs.net"]
  spec.description   = %q{before_create helper to create unique idenfication fields}
  spec.summary       = %q{before_create helper to create unique idenfication fields}
  spec.homepage      = "https://github.com/jGRUBBS/unique_identifier"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rails"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "sqlite3"

end
