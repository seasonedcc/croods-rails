# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Model
      protected

      def model_name
        resource_name.singularize
      end

      def model
        model_name.constantize
      end
    end
  end
end
