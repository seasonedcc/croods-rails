# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module MultiTenancy
      extend ActiveSupport::Concern

      included do
        before_action :authorize_multi_tenancy, unless: :devise_controller?
      end

      protected

      def current_tenant
        @current_tenant ||= current_user.send(Croods.multi_tenancy_by)
      end

      def tenant_param
        "#{Croods.multi_tenancy_by}_id".to_sym
      end

      def tenant_params(model)
        return {} unless Croods.multi_tenancy?

        return {} unless model.has_attribute? tenant_param

        { tenant_param => current_tenant.id }
      end

      def authorize_multi_tenancy
        return unless Croods.multi_tenancy?

        return unless current_user

        return if request.headers['Organization'] == current_tenant.slug

        raise(
          Pundit::NotAuthorizedError,
          'You are not authorized to access this organization'
        )
      end
    end
  end
end
