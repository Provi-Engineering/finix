# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'finix/version'

Gem::Specification.new do |spec|
  spec.name          = 'finix'
  spec.required_ruby_version = '>= 1.9'
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

  spec.add_dependency('faraday', '~> 0.10.0')
  spec.add_dependency('faraday_middleware', '~> 0.10.1')

  if RUBY_VERSION >= '2.0'
    spec.add_dependency('json', '~> 2.0.2')
    spec.add_dependency('addressable', '~> 2.5.0')
  else
    spec.add_dependency('public_suffix', '~> 1.4.6')
    spec.add_dependency('json', '~> 1.8')
    spec.add_dependency('addressable', '~> 2.3')
  end
end
