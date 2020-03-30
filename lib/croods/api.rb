# frozen_string_literal: true

module Croods
  module Api
    class << self
      def initial_schema
        File.read(File.expand_path('api/initial_schema.json', __dir__))
      end

      def json_schema
        schema = JSON.parse(initial_schema)

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
