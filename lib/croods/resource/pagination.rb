# frozen_string_literal: true

module Croods
  module Resource
    module Pagination
      def page_attribute
        @page_attribute ||= Croods::Attribute.new(
          Kaminari.config.param_name, :string, null: true
        )
      end

      def per_page_attribute
        @per_page_attribute ||= Croods::Attribute.new(
          'per_page', :string, null: true
        )
      end

      def pagination_params
        @pagination_params ||= [page_attribute, per_page_attribute]
      end

      def page_attribute_name
        @page_attribute.name
      end

      def page_method_name
        @page_method_name ||= Kaminari.config.page_method_name
      end
    end
  end
end
