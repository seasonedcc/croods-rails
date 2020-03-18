# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Definitions
        TYPES = { datetime: 'string', text: 'string' }.freeze

        class << self
          def schema(resource)
            attributes(resource).merge(identity: identity(resource))
          end

          def attributes(resource)
            attributes = {}

            resource.model.columns_hash.each_value do |attribute|
              attributes[attribute.name] = {
                type: types(attribute)
              }.merge(format(attribute))
            end

            attributes
          end

          def format(attribute)
            return {} unless attribute.type == :datetime

            { format: 'date-time' }
          end

          def types(attribute)
            types = []
            types << type(attribute.type)
            types << 'null' if attribute.null
            types
          end

          def type(type)
            TYPES[type] || type.to_s
          end

          def identity(resource)
            resource.ref(:id)
          end
        end
      end
    end
  end
end
