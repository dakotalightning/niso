# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'niso'
  spec.version       = '2.0.0'
  spec.authors       = ['Dakota Lightning']
  spec.email         = ['im@koda.io']
  spec.homepage      = 'http://github.com/dakotalightning/niso'
  spec.summary       = %q{Server provisioning utility for minimalists}
  spec.description   = %q{Server provisioning utility for minimalists}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'rainbow'
  spec.add_runtime_dependency 'net-ssh'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'minitest'
end
