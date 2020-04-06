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

      def action
        @action ||= resource.actions.find do |action|
          action.name.to_s == action_name
        end
      end

      def execute_service(member_or_collection, params, &block)
        return instance_eval(&block) unless action&.service

        action.service.execute(member_or_collection, params, current_user)
      end
    end
  end
end
