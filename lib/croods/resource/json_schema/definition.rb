# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Definition
        TYPES = {
          datetime: ['string'],
          date: ['string'],
          text: ['string'],
          json: %w[object array],
          jsonb: %w[object array],
          float: ['number']
        }.freeze

        class << self
          def schema(attribute)
            { type: types(attribute) }
              .merge(format(attribute))
              .merge(items(attribute))
          end

          def items(attribute)
            return {} unless %i[json jsonb].include?(attribute.type)

            { items: { type: %w[string number object] } }
          end

          def format(attribute)
            case attribute.type
            when :datetime
              { format: 'date-time' }
            when :date
              { format: 'date' }
            else
              {}
            end
          end

          def types(attribute)
            types = []
            converted_types(attribute.type).each do |converted_type|
              types << converted_type
            end
            null = (
              attribute.null || attribute.default || attribute.default_function
            )
            types << 'null' if null
            types
          end

          def converted_types(type)
            TYPES[type] || [type.to_s]
          end
        end
      end
    end
  end
end
