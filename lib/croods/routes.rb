# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      def mount_croods
        Croods.resources.each do |resource|
          resource.create_model!
          resource.create_controller!
          resources resource.route_name
        end

        Croods.json_schema = Croods::CreateJsonSchema.execute
      end
    end
  end
end
