# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Index
          class << self
            def link(resource)
              {
                href: resource.collection_path,
                method: 'GET',
                rel: 'instances',
                schema: schema(resource),
                targetSchema: target_schema(resource)
              }
            end

            def filters(resource)
              filters = {}

              resource.filters.each do |attribute|
                filters[attribute.name] = Definition.schema(attribute)
              end

              filters
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
