# frozen_string_literal: true

module Croods
  module Resource
    module Names
      def namespace
        to_s.split('::').first
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
    end
  end
end
