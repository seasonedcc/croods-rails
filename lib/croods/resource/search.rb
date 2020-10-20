# frozen_string_literal: true

module Croods
  module Resource
    module Search
      def search_attribute
        @search_attribute ||= Croods::Attribute.new(
          'query', :string, null: true
        )
      end

      def search_params
        @search_params ||= [search_attribute]
      end

      def search_attribute_name
        @search_attribute.name
      end

      def search_method_name
        @search_method_name
      end

      def search_options
        @search_options
      end

      def search_by(name, options = {})
        @search_method_name = name
        @search_options = options
      end
    end
  end
end
