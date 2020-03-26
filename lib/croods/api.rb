# frozen_string_literal: true

module Croods
  module Api
    class << self
      def json_schema
        json = File.read(File.expand_path('api/initial_schema.json', __dir__))
        schema = JSON.parse(json)

        Croods.resources.each do |resource|
          next unless resource.table_exists?

          name = resource.resource_name
          schema['definitions'][name] = resource.json_schema
          schema['properties'][name] = resource.ref
        end

        schema.deep_stringify_keys!
        Committee::Drivers::HyperSchema::Driver.new.parse(schema)
      end
    end
  end
end
