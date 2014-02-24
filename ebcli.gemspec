# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ebifly/version'

Gem::Specification.new do |spec|
  spec.name          = "ebifly"
  spec.version       = Ebifly::VERSION
  spec.authors       = ["Kazuyuki Honda"]
  spec.email         = ["hakobera@gmail.com"]
  spec.summary       = %q{Easy command line interface for Amazon ElasticBeanstalk}
  spec.description   = %q{Easy command line interface for Amazon ElasticBeanstalk}
  spec.homepage      = "https://github.com/hakobera/ebifly"
  spec.license       = "Apache License, Version 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk"
end
