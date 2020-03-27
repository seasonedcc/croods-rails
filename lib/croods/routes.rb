# frozen_string_literal: true

module ActionDispatch
  module Routing
    class Mapper
      def mount_croods
        create_application_controller!

        Croods.resources.each do |resource|
          resource.create_model!
          resource.create_policy!
          resource.create_controller!
          resources resource.route_name
        end

        Croods.json_schema = Croods::Api.json_schema
      end

      def create_application_controller!
        Croods::Controller.instance_eval do
          include DeviseTokenAuth::Concerns::SetUserByToken
        end

        Object.const_set(
          'ApplicationController', Class.new(Croods::Controller)
        )
      end
    end
  end
end
