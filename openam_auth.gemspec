# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'openam_auth/version'

Gem::Specification.new do |spec|
  spec.name          = "openam_auth"
  spec.version       = OpenamAuth::VERSION
  spec.authors       = ["sameera207"]
  spec.email         = ["sameera207@gmail.com"]
  spec.description   = %q{ruby authentication client for OpenAm}
  spec.summary       = %q{ruby authentication client for forgerock OpenAM}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'httparty'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec-rails"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "actionpack"
  spec.add_development_dependency "activesupport"
end
