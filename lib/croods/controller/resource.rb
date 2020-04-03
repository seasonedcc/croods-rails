# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Resource
      protected

      def resource_name
        self.class.to_s.titleize.split.first
      end

      def resource
        "#{resource_name}::Resource".constantize
      end
    end
  end
end
