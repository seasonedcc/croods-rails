# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Collection
          class << self
            def link(resource, action = nil)
              href = resource.collection_path
              href += "/#{action.name}" if action

              {
                href: href,
                method: action&.method&.upcase || 'GET',
                rel: 'instances',
                schema: schema(resource),
                targetSchema: target_schema(resource)
              }
            end

            def filters(resource)
              filters = {}

              resource.filters.each do |attribute|
                model = resource.model

                unless model.has_attribute?(attribute.name) || attribute.name == 'page'
                  attribute.name = "#{attribute.name}_id"
                end

                filters[attribute.name] = definition(attribute)
              end

              filters
            end

            def definition(attribute)
              definition = Definition.schema(attribute)

              {
                anyOf: [{ type: ['array'], items: definition }, definition]
              }
            end

            def required(resource)
              resource.filters.reject(&:null).map(&:name)
            end

            def schema(resource)
              {
                additionalProperties: false,
                properties: filters(resource),
                required: required(resource),
                type: ['object']
              }
            end

            def target_schema(resource)
              {
                anyOf: [
                  { type: ['array'], items: resource.ref },
                  { '$ref': '#/definitions/error' }
                ]
              }
            end
          end
        end
      end
    end
  end
end
