# frozen_string_literal: true

module Croods
  module Resource
    module Filters
      def filter_by(name, optional: nil)
        filters << Croods::Attribute.new(
          name, :string, null: optional
        )
      end

      def default_filters
        page = Croods::Attribute.new('page', :string, null: true)
        per_page = Croods::Attribute.new('per_page', :string, null: true)

        @default_filters ||= [page, per_page]
      end

      def default_filters_names
        default_filters.map(&:name)
      end

      def filters
        @filters ||= [] + default_filters
      end

      def apply_filters(scope, params)
        filters.each do |attribute|
          next if default_filters_names.include?(attribute.name)

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
