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
          create_resource_routes!(resource)
        end

        Croods.json_schema = Croods::Api.json_schema
      end

      def create_resource_routes!(resource)
        resources(
          resource.route_name,
          param: resource.identifier,
          only: resource.actions.map(&:name)
        ) do
          resource.additional_actions.each do |action|
            public_send(action.method, action.name, on: action.on)
          end
        end
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
