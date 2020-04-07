# frozen_string_literal: true

module Croods
  module Resource
    module Filters
      def filter_by(association, optional: nil)
        filters << Croods::Attribute.new(
          "#{association}_id", :string, null: optional
        )
      end

      def filters
        @filters ||= []
      end

      def apply_filters(scope, params)
        filters.each do |attribute|
          value = params[attribute.name]
          next unless value

          scope = scope.where(attribute.name => value)
        end

        scope
      end
    end
  end
end
