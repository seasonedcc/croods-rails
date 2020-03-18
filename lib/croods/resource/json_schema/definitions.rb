# frozen_string_literal: true

require_relative 'links/index'

module Croods
  module Resource
    module JsonSchema
      module Definitions
        class << self
          def schema(resource)
            attributes(resource).merge(identity: identity(resource))
          end

          def attributes(resource)
            attributes = {}

            resource.model.columns_hash.each_value do |attribute|
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

          def identity(resource)
            resource.ref(:id)
          end
        end
      end
    end
  end
end
