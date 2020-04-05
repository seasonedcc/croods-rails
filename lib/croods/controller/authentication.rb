# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Authentication
      extend ActiveSupport::Concern

      included do
        before_action :authenticate_user!, unless: :devise_controller?
      end

      protected

      def user_params(model)
        return {} unless resource.user_is_the_owner?
        return {} unless model.has_attribute?(:user_id)

        { user_id: current_user&.id }
      end
    end
  end
end
