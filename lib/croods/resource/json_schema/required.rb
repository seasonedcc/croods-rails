# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Required
        class << self
          def schema(resource, request: false)
            required = []

            properties = resource.response_attributes
            properties = resource.request_attributes if request

            properties.each_value do |attribute|
              next if ignore?(request, attribute)

              required << attribute.name unless attribute.null
            end

            required
          end

          def ignore?(request, attribute)
            return unless request

            return true if attribute.default || attribute.default_function

            %w[created_at updated_at].include?(attribute.name)
          end
        end
      end
    end
  end
end
