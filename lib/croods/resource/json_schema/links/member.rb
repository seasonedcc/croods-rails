# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Member
          class << self
            def link(resource, action)
              {
                href: "#{resource.member_path}/#{action.name}",
                method: action.method.upcase,
                rel: 'self',
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
