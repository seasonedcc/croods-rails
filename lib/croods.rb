# frozen_string_literal: true

require 'committee'

require 'croods/railtie'
require 'croods/model'
require 'croods/controller'
require 'croods/resource'
require 'croods/routes'
require 'croods/middleware'
require 'croods/create_json_schema'

module Croods
  cattr_accessor :namespaces, :json_schema

  def self.initialize_for(*namespaces)
    Croods.namespaces = namespaces.map(&:to_s).freeze
    Middleware.insert!
  end
end
