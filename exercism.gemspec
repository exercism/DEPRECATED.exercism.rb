# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'exercism/version'

Gem::Specification.new do |spec|
  spec.name          = "exercism"
  spec.version       = Exercism::VERSION
  spec.authors       = ["Katrina Owen"]
  spec.email         = ["katrina.owen@gmail.com"]
  spec.description   = %q{Client gem for the exercism.io app}
  spec.summary       = %q{This gem provides a command line client to allow users of the exercism.io application to easily fetch and submit assignments.}
  spec.homepage      = "https://github.com/kytrinyx/exercism"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday"
  spec.add_dependency "thor"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "vcr", '~> 2.4'
  spec.add_development_dependency "fakeweb"
  spec.add_development_dependency "approvals"
  spec.add_development_dependency "minitest", '~> 5.0'
end
