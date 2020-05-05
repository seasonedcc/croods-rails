# frozen_string_literal: true

module Croods
  module Resource
    module JsonSchema
      module Definition
        TYPES = {
          datetime: 'string',
          date: 'string',
          text: 'string',
          json: 'object',
          float: 'number'
        }.freeze

        class << self
          def schema(attribute)
            { type: types(attribute) }.merge(format(attribute))
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
            types << type(attribute.type)
            types << 'null' if attribute.null
            types
          end

          def type(type)
            TYPES[type] || type.to_s
          end
        end
      end
    end
  end
end
