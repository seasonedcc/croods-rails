# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Update
          class << self
            def link(resource)
              {
                href: "/#{resource.route_name}/{(%23%2Fdefinitions" \
                  "%2F#{resource.resource_name}%2Fdefinitions%2Fid)}",
                method: 'PUT',
                rel: 'self',
                schema: schema(resource),
                targetSchema: target_schema(resource)
              }
            end

            def schema(resource)
              {
                additionalProperties: false,
                properties: Properties.schema(resource, write: true),
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
