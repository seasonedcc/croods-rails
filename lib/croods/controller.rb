# frozen_string_literal: true

require_relative 'controller/actions'
require_relative 'controller/not_found'
require_relative 'controller/already_taken'
require_relative 'controller/record_invalid'

module Croods
  class Controller < ActionController::API
    include Pundit

    before_action :authenticate_user!
    after_action :verify_authorized, unless: :devise_controller?
    after_action :verify_policy_scoped, unless: :devise_controller?

    include NotFound
    include AlreadyTaken
    include RecordInvalid

    protected

    def member
      policy_scope(model).find(params[:id])
    end

    def member_params
      params.permit(resource.request_attributes.keys)
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
