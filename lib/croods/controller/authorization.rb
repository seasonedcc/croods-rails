# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Authorization
      extend ActiveSupport::Concern
      include Pundit

      included do
        after_action :verify_authorized, unless: :devise_controller?
        after_action :verify_policy_scoped, unless: :devise_controller?
        rescue_from Pundit::NotAuthorizedError, with: :forbidden
      end

      def policy_scope(scope)
        @_pundit_policy_scoped = true
        resource.policy_scope(action_name)
          .new(tenant: header_tenant, user: current_user, scope: scope).resolve
      end

      protected

      def forbidden(exception)
        render status: :forbidden, json: {
          id: 'forbidden',
          message: exception.message
        }
      end
    end
  end
end
