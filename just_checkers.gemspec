# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'just_checkers/version'

Gem::Specification.new do |spec|
  spec.name          = "just_checkers"
  spec.version       = JustCheckers::VERSION
  spec.authors       = ["Mark Humphreys"]
  spec.email         = ["mark@mrlhumphreys.com"]

  spec.summary       = %q{A checkers engine written in ruby}
  spec.description   = %q{Provides a representation of a checkers game complete with rules enforcement and serialisation.}
  spec.homepage      = "https://github.com/mrlhumphreys/just_checkers"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '~> 2.1'

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'minitest', '~> 5.8'
end
