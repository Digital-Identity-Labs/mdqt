# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mdqt/version'

Gem::Specification.new do |spec|
  spec.name          = "mdqt"
  spec.version       = MDQT::VERSION
  spec.authors       = ["Pete Birkinshaw"]
  spec.email         = ["pete@digitalidentitylabs.com"]

  spec.summary       = %q{Library and commandline utility for accessing MDQ services}
  spec.description   = %q{Library and commandline utility for downloading SAML metadata from MDQ services}
  spec.homepage      = "https://github.com/Digital-Identity-Labs/mdqt"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.2.0'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'commander', "~>4.6"
  spec.add_dependency 'faraday', "~>1.8"
  spec.add_dependency 'faraday_middleware', "~>1.2"
  spec.add_dependency 'faraday-http-cache', "~>2.2"
  spec.add_dependency 'typhoeus', "~>1.4"
  spec.add_dependency 'activesupport', "~>6.1"
  spec.add_dependency 'dalli', "~>3.0"
  spec.add_dependency 'pastel', "~>0.8"
  spec.add_dependency 'terminal-table', "~>3.0"
  spec.add_dependency 'concurrent-ruby-ext', "1.1.9"


  #spec.add_dependency 'xmldsig'

  spec.add_development_dependency "bundler", "~> 2"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.10"
  spec.add_development_dependency "cucumber", "~> 7.1"
  spec.add_development_dependency "aruba", "~> 2.0"
  spec.add_development_dependency "vcr", "~>  6.0"
  spec.add_development_dependency "yard", "~> 0.9"
  #spec.add_development_dependency "yard-cucumber", "~> 4.0"
end
