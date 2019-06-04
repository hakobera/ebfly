# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ebfly/version'

Gem::Specification.new do |spec|
  spec.name          = "ebfly"
  spec.version       = Ebfly::VERSION
  spec.authors       = ["Kazuyuki Honda"]
  spec.email         = ["hakobera@gmail.com"]
  spec.summary       = %q{Simple command line interface for AWS ElasticBeanstalk}
  spec.description   = %q{Simple command line interface for AWS ElasticBeanstalk}
  spec.homepage      = "https://github.com/hakobera/ebfly"
  spec.license       = "Apache License, Version 2.0"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "aws-sdk-s3"
  spec.add_runtime_dependency "aws-sdk-elasticbeanstalk"
  spec.add_runtime_dependency "thor"

  spec.add_development_dependency "rake"
end
