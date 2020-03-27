# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Create
          class << self
            def link(resource)
              {
                href: resource.collection_path,
                method: 'POST',
                rel: 'new',
                schema: schema(resource),
                targetSchema: target_schema(resource)
              }
            end

            def schema(resource)
              {
                additionalProperties: false,
                properties: Properties.schema(resource, request: true),
                required: Required.schema(resource, request: true),
                type: ['object']
              }
            end

            def target_schema(resource)
              {
                anyOf: [
                  resource.ref,
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
