# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'croods/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = 'croods'
  spec.version     = Croods::VERSION
  spec.authors     = ['Daniel Weinmann']
  spec.email       = ['danielweinmann@gmail.com']
  spec.homepage    = 'https://github.com/SeasonedSoftware/croods-rails'
  spec.summary     = 'A framework for creating CRUDs in Rails APIs'
  spec.description = 'A framework for creating CRUDs in Rails APIs'
  spec.license     = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the
  # 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing
  # to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = Dir[
    '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md'
  ]

  spec.add_dependency 'rails', '~> 6.0.2', '>= 6.0.2.1'

  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rubocop', '0.80.1'
  spec.add_development_dependency 'rubocop-rspec', '1.38.1'
end
