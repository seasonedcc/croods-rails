# frozen_string_literal: true

require 'rack/cors'
require 'committee'
require 'devise'
require 'devise_token_auth'
require 'pundit'

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

module Croods
  cattr_accessor :namespaces, :json_schema

  def self.initialize_for(*namespaces)
    Croods.namespaces = namespaces.map(&:to_s).freeze
    Middleware.insert!
  end

  def self.resources
    Croods.namespaces.map do |namespace|
      "#{namespace.camelcase(:upper)}::Resource".constantize
    end
  end
end
