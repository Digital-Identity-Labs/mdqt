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

  spec.required_ruby_version = '>= 2.1.0'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'commander', "~>4.4"
  spec.add_dependency 'faraday', "~>0.15"
  spec.add_dependency 'faraday_middleware', "~>0.12"
  spec.add_dependency 'faraday-http-cache', "~>2.0"
  spec.add_dependency 'typhoeus', "~>1.3"
  spec.add_dependency 'activesupport', "~>5.2"
  spec.add_dependency 'dalli', "~>2.7"
  spec.add_dependency 'pastel', "~>0.7"

  #spec.add_dependency 'xmldsig'

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "cucumber", "~> 3.1"
  spec.add_development_dependency "aruba", "~> 0.14"
  spec.add_development_dependency "vcr", "~>  4.0"
  spec.add_development_dependency "yard", "~> 0.9"
  spec.add_development_dependency "yard-cucumber", "~> 4.0"
end
