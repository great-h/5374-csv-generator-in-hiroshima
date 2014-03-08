# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'hiroshima5374/version'

Gem::Specification.new do |spec|
  spec.name          = "5374-csv-generator-in-hiroshima"
  spec.version       = Hiroshima5374::VERSION
  spec.authors       = ["Tomohiko Himura"]
  spec.email         = ["eiel.hal@gmail.com"]
  spec.summary       = %q{generate csv for hiroshima.5374.jp}
  spec.description   = %q{generate csv for hiroshima.5374.jp}
  spec.homepage      = "http://hiroshima.5374.jp"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry-byebug"
  spec.add_dependency "nokogiri"
end
