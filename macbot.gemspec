# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'macbot/metadata'

Gem::Specification.new do |spec|
  spec.name          = 'macbot'
  spec.version       = Macbot::VERSION
  spec.authors       = ['Hilde Vestol']
  spec.email         = ['hilde@rubynor.com']

  spec.summary       = Macbot::SUMMARY
  spec.description   = Macbot::SUMMARY
  spec.homepage      = 'https://github.com/hildevestol/macbot'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'bin'
  spec.executables   = ['macbot']
  spec.require_paths = ['lib']

  spec.add_dependency 'commander', '~> 4.1.5'

  spec.add_development_dependency 'bundler', '~> 1.9'
  spec.add_development_dependency 'rake', '~> 10.0'
end
