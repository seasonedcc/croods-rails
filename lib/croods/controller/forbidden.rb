# frozen_string_literal: true

module Croods
  class Controller < ActionController::API
    module Forbidden
      extend ActiveSupport::Concern

      included do
        rescue_from Pundit::NotAuthorizedError, with: :forbidden
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
