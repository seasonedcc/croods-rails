# frozen_string_literal: true

require_relative 'resource/json_schema'

module Croods
  module Resource
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    class_methods do
      include JsonSchema

      def namespace
        to_s.split('::').first
      end

      def collection_path
        "/#{route_name}"
      end

      def member_path
        "/#{route_name}/{(%23%2Fdefinitions" \
          "%2F#{resource_name}%2Fdefinitions%2Fid)}"
      end

      def route_name
        namespace.downcase
      end

      def model_name
        namespace.singularize
      end

      def resource_name
        model_name.downcase
      end

      def model
        model_name.constantize
      end

      def create_model!
        Object.const_set(model_name, Class.new(Model))
      end

      def create_controller!
        Object.const_set("#{namespace}Controller", Class.new(Controller))
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
