# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      def mount_croods
        Croods.namespaces.each do |namespace|
          resource = "#{namespace.camelcase(:upper)}::Resource".constantize
          resource.create_model!
          resource.create_controller!
          resources resource.resource_name
        end

        Croods.json_schema = Croods::CreateJsonSchema.execute
      end
    end
  end
end
