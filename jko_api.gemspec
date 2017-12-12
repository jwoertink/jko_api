# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jko_api/version'

Gem::Specification.new do |spec|
  spec.name          = "jko_api"
  spec.version       = JkoApi::VERSION
  spec.authors       = ["Jeremy Woertink"]
  spec.email         = ["jeremywoertink@gmail.com"]
  spec.summary       = %q{A Rails API gem}
  spec.description   = %q{Some Rails API code written by JustinKo and ported to a badly written gem}
  spec.homepage      = "https://github.com/jwoertink/jko_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.7"
  spec.add_development_dependency "rake", ">= 10.0"
  spec.add_dependency "responders", "2.4.0"
  spec.add_dependency "rails", ">= 4.2.7"
  spec.add_dependency "warden-oauth2"
end
