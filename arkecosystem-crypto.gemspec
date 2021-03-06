lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'arkecosystem/crypto/version'

Gem::Specification.new do |spec|
  spec.name          = 'arkecosystem-crypto'
  spec.version       = ArkEcosystem::Crypto::VERSION
  spec.authors       = ['Brian Faust']
  spec.email         = ['brian@ark.io']

  spec.summary       = 'A simple Ruby Cryptography Implementation for the Ark Blockchain.'
  spec.description   = 'A simple Ruby Cryptography Implementation for the Ark Blockchain.'
  spec.homepage      = 'https://github.com/ArkEcosystem/ruby-crypto'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = 'https://rubygems.org'
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files         = Dir.glob('lib/**/*.rb')
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 12.0'
  spec.add_development_dependency 'rspec', '~> 3.8'

  spec.add_dependency 'btcruby'
  spec.add_dependency 'deep_hash_transform'
end
