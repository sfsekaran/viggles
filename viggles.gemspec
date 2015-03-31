# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'viggles/version'

Gem::Specification.new do |spec|
  spec.name          = "viggles"
  spec.version       = Viggles::VERSION
  spec.authors       = ["Sathya Sekaran"]
  spec.email         = ["sfsekaran@gmail.com"]

  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  # end

  spec.summary       = %q{A Viggle Points API Gem}
  spec.description   = %q{Use viggles to update points balances, administrate users, and perform other actions.}
  spec.homepage      = "http://github.com/sfsekaran/viggles"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.8"
  spec.add_development_dependency "rake", "~> 10.0"

  spec.add_runtime_dependency "rest-client", "~> 1.6.7"
end
