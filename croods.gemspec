# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'croods/version'

# rubocop:disable Metrics/BlockLength
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

  spec.files = Dir[
    '{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md'
  ]

  spec.add_dependency 'api-pagination', '4.8.2'
  spec.add_dependency 'committee', '3.3.0'
  spec.add_dependency 'devise_token_auth', '1.1.3'
  spec.add_dependency 'kaminari', '1.2.1'
  spec.add_dependency 'pg_search', '2.3.4'
  spec.add_dependency 'pundit', '2.1.0'
  spec.add_dependency 'rails', '5.2.6'
  spec.add_dependency 'schema_associations', '1.2.7'
  spec.add_dependency 'schema_auto_foreign_keys', '0.1.3'
  spec.add_dependency 'schema_validations', '2.3.0'

  spec.add_development_dependency 'gem-release'
  spec.add_development_dependency 'pg'
  spec.add_development_dependency 'rack-cors', '1.1.1'
  spec.add_development_dependency 'rspec-rails', '~> 4.0.1'
  spec.add_development_dependency 'rspec_junit_formatter', '~> 0.4.1'
  spec.add_development_dependency 'rubocop', '~> 1.21.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 2.5.0'
  spec.add_development_dependency 'simplecov', '~> 0.17.0'
  spec.add_development_dependency 'timecop', '0.9.1'
end
# rubocop:enable Metrics/BlockLength
