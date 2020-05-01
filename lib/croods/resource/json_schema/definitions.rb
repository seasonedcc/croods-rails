# frozen_string_literal: true

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

            resource.definitions.each_value do |attribute|
              attributes[attribute.name] = Definition.schema(attribute)
            end

            attributes
          end

          def identity(resource)
            resource.ref(resource.identifier)
          end
        end
      end
    end
  end
end
