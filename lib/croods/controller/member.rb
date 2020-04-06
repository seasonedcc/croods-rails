# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Member
      protected

      def member
        return @member ||= member_by_id if resource.identifier == :id

        @member ||= member_by_identifier
      end

      def member_by_id
        policy_scope(model).find(params[:id])
      end

      def member_by_identifier
        policy_scope(model).find_by!(resource.identifier => identifier)
      end

      def identifier
        params[resource.identifier]
      end

      def member_params
        params
          .permit(resource.request_attributes.keys)
          .merge(
            params
              .require(resource.resource_name)
              .permit(resource.request_attributes.keys)
          )
      end

      def new_member
        policy_scope(model).new(
          member_params
            .merge(tenant_params(model))
            .merge(user_params(model))
        )
      end
    end
  end
end
