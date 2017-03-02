# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'server-status/version'

Gem::Specification.new do |spec|
  spec.name          = "server-status"
  spec.version       = ServerStatus::VERSION
  spec.authors       = ["James Brooks"]
  spec.email         = ["james@jamesbrooks.net"]

  spec.summary       = "Command line tool for quickly fetching and displaying vital host metrics"
  spec.description   = "Command line tool for quickly fetching and displaying vital host metrics"
  spec.homepage      = "https://github.com/jamesbrooks/server-status"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = ["server-status"]
  spec.require_paths = ["lib"]

  spec.add_dependency "commander", "~> 4.3"
  spec.add_dependency "colorize", "~> 0.8"
  spec.add_dependency "tty-progressbar", "~> 0.10.1"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", ">= 10.0"
end
