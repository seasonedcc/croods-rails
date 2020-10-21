# frozen_string_literal: true

module Croods
  module Resource
    module Search
      def search_attribute
        return if skip_search?

        @search_attribute ||= Croods::Attribute.new(
          'query', :string, null: true
        )
      end

      def search_params
        return [] if skip_search?

        @search_params ||= [search_attribute]
      end

      def search_attribute_name
        return if skip_search?

        @search_attribute.name
      end

      def search_method_name
        @search_method_name ||= :search
      end

      def default_search_options
        searchable = []

        attributes.each do |key, value|
          searchable << key if value.type.in? %i[string text]
        end

        {
          against: searchable
        }
      end

      def search_options
        @search_options ||= default_search_options
      end

      def search_block
        @search_block
      end

      def skip_search?
        @skip_search
      end

      def skip_search
        @skip_search ||= true
      end

      def search_by(name, options = {}, &block)
        @search_method_name = name
        @search_options = options
        @search_block = block
      end
    end
  end
end
