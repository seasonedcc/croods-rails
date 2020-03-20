# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Create
          class << self
            def link(resource)
              {
                href: "/#{resource.route_name}",
                method: 'POST',
                rel: 'new',
                schema: schema(resource),
                targetSchema: target_schema(resource)
              }
            end

            def schema(resource)
              {
                additionalProperties: false,
                properties: Properties.schema(resource, write: true),
                required: Required.schema(resource, write: true),
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
