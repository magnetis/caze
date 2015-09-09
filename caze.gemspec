# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'caze/version'

Gem::Specification.new do |spec|
  spec.name          = "caze"
  spec.version       = Caze::VERSION
  spec.authors       = ["Philip Sampaio", "Fabiano Beselga"]
  spec.email         = ["philip@magnetis.com.br", "fabiano@magnetis.com.br"]
  spec.summary       = %q{A DSL to define use cases}
  spec.description   = %q{With Caze it's easy to define use cases and entry points.}
  spec.homepage      = "https://github.com/magnetis/caze"
  spec.license       = "Apache License 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]
  spec.required_ruby_version = '>= 2.0.0'

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3"
  spec.add_development_dependency "pry"

  spec.add_dependency "activesupport", ">= 3"
end
