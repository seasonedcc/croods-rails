# frozen_string_literal: true

module Croods
  module Resource
    extend ActiveSupport::Concern

    class_methods do
      def namespace
        to_s.split('::').first
      end

      def resource_name
        namespace.downcase
      end

      def model_name
        namespace.singularize
      end

      def create_model!
        Object.const_set(model_name, Class.new(Model))
      end

      def create_controller!
        Object.const_set("#{namespace}Controller", Class.new(Controller))
      end
    end
  end
end
