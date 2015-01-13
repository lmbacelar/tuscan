# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tuscan/version'

Gem::Specification.new do |spec|
  spec.name          = "tuscan"
  spec.version       = Tuscan::VERSION
  spec.authors       = ["Luis Bacelar"]
  spec.email         = ["lmbacelar@gmail.com"]
  spec.summary       = %q{Converts to and from temperature for standard (S)PRT's and thermocouples}
  spec.description   = %q{Converts from electrical signal to temperature and vice-versa for ITS-90 SPRT's, IEC 60751 PRT's and IEC 60584 thermocouples}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'byebug'
end
