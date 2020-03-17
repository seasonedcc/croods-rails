# frozen_string_literal: true

module Croods
  class CreateJsonSchema
    def self.execute
      new.execute
    end

    attr_accessor :schema

    def initialize
      json = File.read(File.expand_path('initial_schemas/api.json', __dir__))
      self.schema = JSON.parse(json)
    end

    def execute
      Croods.resources.each do |resource|
        name = resource.resource_name
        schema['definitions'][name] = resource.json_schema
        schema['properties'][name] = {
          '$ref': "#/definitions/#{name}"
        }
      end

      puts schema.deep_stringify_keys!

      Committee::Drivers::HyperSchema::Driver.new.parse(schema)
    end
  end
end
