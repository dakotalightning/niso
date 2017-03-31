# coding: utf-8

Gem::Specification.new do |spec|
  spec.name          = 'niso'
  spec.version       = '2.0.3'
  spec.authors       = ['Dakota Lightning']
  spec.email         = ['im@koda.io']
  spec.homepage      = 'http://github.com/dakotalightning/niso'
  spec.summary       = %q{Server provisioning utility}
  spec.description   = %q{Fork of the sunzi project, Plugin based Server provisioning utility}
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'thor', '~> 0.19'
  spec.add_runtime_dependency 'rainbow', '~> 2.0'
  spec.add_runtime_dependency 'net-ssh', '~> 3.2'
  spec.add_development_dependency 'rake', '~> 10.5'
  spec.add_development_dependency 'minitest', '~> 5.8'
end
