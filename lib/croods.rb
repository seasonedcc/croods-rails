# frozen_string_literal: true

require 'rack/cors'
require 'committee'
require 'devise'
require 'devise_token_auth'
require 'pundit'
require 'schema_associations'
require 'schema_auto_foreign_keys'
require 'schema_validations'

module Croods
  cattr_accessor :namespaces, :json_schema, :multi_tenancy_by

  class << self
    def initialize_for(*namespaces, multi_tenancy_by: nil)
      self.multi_tenancy_by = multi_tenancy_by
      self.namespaces = namespaces.map(&:to_s).freeze
      Middleware.insert!
    end

    def resources
      namespaces.map do |namespace|
        "#{namespace.camelcase(:upper)}::Resource".constantize
      end
    end

    def multi_tenancy?
      !multi_tenancy_by.nil?
    end
  end
end

require 'croods/railtie'
require 'croods/model'
require 'croods/attribute'
require 'croods/controller'
require 'croods/action'
require 'croods/policy'
require 'croods/resource'
require 'croods/routes'
require 'croods/middleware'
require 'croods/api'
