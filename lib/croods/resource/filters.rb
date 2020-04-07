# frozen_string_literal: true

module Croods
  module Resource
    module Filters
      def filter_by(name, optional: nil)
        filters << Croods::Attribute.new(
          name, :string, null: optional
        )
      end

      def filters
        @filters ||= []
      end

      def apply_filters(scope, params)
        filters.each do |attribute|
          unless model.has_attribute?(attribute.name)
            attribute.name = "#{attribute.name}_id"
          end

          value = params[attribute.name]
          next unless value

          scope = scope.where(attribute.name => value)
        end

        scope
      end
    end
  end
end
