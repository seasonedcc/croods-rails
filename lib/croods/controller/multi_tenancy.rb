# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module MultiTenancy
      extend ActiveSupport::Concern

      included do
        before_action :authorize_multi_tenancy, unless: :devise_controller?
      end

      protected

      def tenant_model
        return unless Croods.multi_tenancy?

        Croods.multi_tenancy_by.to_s.camelize.constantize
      end

      def header_tenant
        return unless Croods.multi_tenancy?

        tenant_model.find_by!(slug: request.headers['Tenant'])
      end

      def current_tenant
        return unless Croods.multi_tenancy?

        @current_tenant ||= current_user&.tenant
      end

      def tenant_params(model)
        return {} unless Croods.multi_tenancy?

        return {} unless model.has_attribute? Croods.tenant_attribute

        { Croods.tenant_attribute => current_tenant.id }
      end

      def authorize_multi_tenancy
        return unless Croods.multi_tenancy?

        return unless current_user

        return if request.headers['Tenant'] == current_tenant.slug

        raise(
          Pundit::NotAuthorizedError,
          'You are not authorized to access this organization'
        )
      end
    end
  end
end
