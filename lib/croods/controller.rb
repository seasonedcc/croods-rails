# frozen_string_literal: true

require_relative 'controller/actions'
require_relative 'controller/not_found'
require_relative 'controller/already_taken'
require_relative 'controller/record_invalid'
require_relative 'controller/forbidden'
require_relative 'controller/multi_tenancy'

module Croods
  class Controller < ActionController::API
    include Pundit

    before_action :authenticate_user!, unless: :devise_controller?
    after_action :verify_authorized, unless: :devise_controller?
    after_action :verify_policy_scoped, unless: :devise_controller?

    include NotFound
    include AlreadyTaken
    include RecordInvalid
    include Forbidden
    include MultiTenancy

    def policy_scope(scope)
      @_pundit_policy_scoped = true
      resource.policy_scope(action_name)
        .new(tenant: header_tenant, user: current_user, scope: scope).resolve
    end

    protected

    def user_params(model)
      return {} unless model.has_attribute? :user_id

      { user_id: current_user&.id }
    end

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

    def resource_name
      self.class.to_s.titleize.split.first
    end

    def resource
      "#{resource_name}::Resource".constantize
    end

    def model_name
      resource_name.singularize
    end

    def model
      model_name.constantize
    end
  end
end
