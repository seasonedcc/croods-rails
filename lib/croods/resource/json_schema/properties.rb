# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Properties
        class << self
          def schema(resource, request: false)
            attributes = {}

            properties = resource.response_attributes
            properties = resource.request_attributes if request

            properties.each_value do |attribute|
              next if ignore?(request, attribute)

              attributes[attribute.name] = resource.ref(attribute.name)
            end

            attributes
          end

          def ignore?(request, attribute)
            return unless request

            %w[id created_at updated_at].include?(attribute.name)
          end
        end
      end
    end
  end
end
