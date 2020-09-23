# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finix/version'

Gem::Specification.new do |spec|
  spec.name          = 'finix'
  spec.required_ruby_version = '>= 2.5'
  spec.version       = Finix::VERSION
  spec.authors       = ['finix-payments']
  spec.email         = ['support@finixpayments.com']

  spec.summary       = %q{Finix Ruby Client}
  spec.description   = %q{Finix Ruby Client}
  spec.homepage      = 'https://www.finixpayments.com'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'bin'
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency('faraday', '~> 1.0')
  spec.add_dependency('faraday_middleware', '~> 1.0')
  spec.add_dependency('json', '~> 2.3')
  spec.add_dependency('addressable', '~> 2.7.0')
end
