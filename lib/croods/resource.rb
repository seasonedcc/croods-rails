# frozen_string_literal: true

require_relative 'resource/names'
require_relative 'resource/paths'
require_relative 'resource/json_schema'

module Croods
  module Resource
    extend ActiveSupport::Concern

    class_methods do
      include Names
      include Paths
      include JsonSchema

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
  end
end
