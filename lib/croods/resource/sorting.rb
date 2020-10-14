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

      def sort_by(attribute = nil)
        return @sort_by ||= :created_at unless attribute

        @sort_by ||= attribute
      end
    end
  end
end
