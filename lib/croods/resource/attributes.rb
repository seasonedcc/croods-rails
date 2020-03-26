# frozen_string_literal: true

module Croods
  module Resource
    module Attributes
      def params
        attributes.merge(additional_params)
      end

      def attributes
        model.columns_hash.merge(additional_attributes)
      end

      def add_attribute(name, type, **options)
        attribute = Croods::Attribute.new(name, type, **options)
        additional_attributes[name.to_s] = attribute
      end

      def add_param(name, type, **options)
        attribute = Croods::Attribute.new(name, type, **options)
        additional_params[name.to_s] = attribute
      end

      def additional_attributes
        @additional_attributes ||= {}
      end

      def additional_params
        @additional_params ||= {}
      end
    end
  end
end
