# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      TYPES = { datetime: 'string', text: 'string' }.freeze

      def json_schema
        return @json_schema if @json_schema

        path = File.expand_path('../initial_schemas/resource.json', __dir__)
        @json_schema = JSON.parse(File.read(path))
        @json_schema['title'] = model.model_name.human
        @json_schema['definitions'] = definitions
        @json_schema['properties'] = properties
        @json_schema['required'] = required
        @json_schema
      end

      def definitions
        attribute_definitions.merge(identity: identity)
      end

      def properties
        attributes = {}

        model.columns_hash.each_value do |attribute|
          attributes[attribute.name] = ref(attribute.name)
        end

        attributes
      end

      def required
        required = []

        model.columns_hash.each_value do |attribute|
          required << attribute.name unless attribute.null
        end

        required
      end

      def attribute_definitions
        attributes = {}

        model.columns_hash.each_value do |attribute|
          attributes[attribute.name] = {
            type: attribute_types(attribute)
          }.merge(attribute_format(attribute))
        end

        attributes
      end

      def attribute_format(attribute)
        return {} unless attribute.type == :datetime

        { format: 'date-time' }
      end

      def attribute_types(attribute)
        types = []
        types << attribute_type(attribute.type)
        types << 'null' if attribute.null
        types
      end

      def attribute_type(type)
        TYPES[type] || type.to_s
      end

      def identity
        ref(:id)
      end

      def ref(attribute)
        {
          '$ref': "#/definitions/#{resource_name}/definitions/#{attribute}"
        }
      end
    end
  end
end
