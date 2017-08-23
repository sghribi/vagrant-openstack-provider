lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-openstack-provider/version'

Gem::Specification.new do |gem|
  gem.name          = 'vagrant-openstack-provider-illuin'
  gem.version       = VagrantPlugins::Openstack::VERSION
  gem.authors       = ['Guillaume Giamarchi', 'Julien Vey']
  gem.email         = ['ghribi.samy@gmail.com']
  gem.description   = 'Enables Vagrant to manage machines in OpenStack Cloud.'
  gem.summary       = 'Enables Vagrant to manage machines in OpenStack Cloud.'
  gem.homepage      = 'https://github.com/sghribi/vagrant-openstack-provider'
  gem.license       = 'MIT'

  gem.add_dependency 'json', '>= 1.8.1', '< 3.0'
  gem.add_dependency 'rest-client', '>= 1.6.0', '< 3.0'
  gem.add_dependency 'terminal-table', '1.4.5'
  gem.add_dependency 'sshkey', '1.6.1'
  gem.add_dependency 'colorize', '0.7.3'

  # Constraint rake to properly handle deprecated method usage
  # from within rspec 3.1.z
  gem.add_development_dependency 'rake', '~> 11.3.0'
  gem.add_development_dependency 'rspec', '~> 3.1.0'
  gem.add_development_dependency 'rspec-its', '~> 1.0.1'
  gem.add_development_dependency 'rspec-expectations', '~> 3.1.2'
  gem.add_development_dependency 'webmock', '~> 1.18.0'
  gem.add_development_dependency 'fakefs', '~> 0.5.2'

  gem.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  gem.executables   = gem.files.grep(/^bin\//).map { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(/^(test|spec|features)\//)
  gem.require_paths = ['lib']
end
