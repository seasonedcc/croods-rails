# frozen_string_literal: true

module Croods
  module Resource
    module Sorting
      def order_by_attribute
        @order_by_attribute ||= Croods::Attribute.new(
          'order_by', :string, null: true
        )
      end

      def order_attribute
        @order_attribute ||= Croods::Attribute.new(
          'order', :string, null: true
        )
      end

      def order_params
        @order_params ||= [order_by_attribute, order_attribute]
      end

      def sort_by_method?
        sort_by.is_a?(Symbol) && !sort_by.to_s.in?(attribute_names) &&
          model.respond_to?(sort_by)
      end

      def sort_by(sort = nil)
        return @sort_by ||= :created_at unless sort

        @sort_by ||= sort
      end
    end
  end
end
