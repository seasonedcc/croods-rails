# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Links
        module Destroy
          class << self
            def link(resource)
              {
                href: resource.member_path,
                method: 'DELETE',
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
