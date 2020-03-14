# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      def mount_croods(*namespaces)
        namespaces.each do |namespace|
          resource = "#{namespace}::Resource".constantize
          resource.create_model!
          resource.create_controller!
          resources resource.resource_name
        end
      end
    end
  end
end
