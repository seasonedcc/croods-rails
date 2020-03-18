# frozen_string_literal: true

require_relative 'links/index'

module Croods
  module Resource
    module JsonSchema
      module Required
        def self.schema(resource)
          required = []

          resource.model.columns_hash.each_value do |attribute|
            required << attribute.name unless attribute.null
          end

          required
        end
      end
    end
  end
end
