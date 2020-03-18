# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Properties
        def self.schema(resource)
          attributes = {}

          resource.model.columns_hash.each_value do |attribute|
            attributes[attribute.name] = resource.ref(attribute.name)
          end

          attributes
        end
      end
    end
  end
end
