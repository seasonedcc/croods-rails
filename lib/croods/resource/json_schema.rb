# frozen_string_literal: true

require_relative 'json_schema/definitions'
require_relative 'json_schema/properties'
require_relative 'json_schema/required'
require_relative 'json_schema/links'

module Croods
  module Resource
    module JsonSchema
      TYPES = { datetime: 'string', text: 'string' }.freeze

      def json_schema
        return @json_schema if @json_schema

        path = File.expand_path('../initial_schemas/resource.json', __dir__)
        @json_schema = JSON.parse(File.read(path))
        @json_schema['definitions'] = Definitions.schema(self)
        @json_schema['properties'] = Properties.schema(self)
        @json_schema['required'] = Required.schema(self)
        @json_schema['links'] = Links.schema(self)
        @json_schema
      end

      def ref(attribute = nil)
        {
          '$ref': "#/definitions/#{resource_name}" +
            (attribute ? "/definitions/#{attribute}" : '')
        }
      end
    end
  end
end
