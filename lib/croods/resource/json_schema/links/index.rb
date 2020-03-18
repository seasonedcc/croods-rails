# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Index
          class << self
            def link(resource)
              {
                href: "/#{resource.route_name}",
                method: 'GET',
                rel: 'instances',
                schema: schema,
                targetSchema: target_schema(resource)
              }
            end

            def schema
              {
                strictProperties: true,
                properties: {},
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
